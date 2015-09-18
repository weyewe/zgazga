class VirtualOrderClearance < ActiveRecord::Base
  belongs_to :virtual_delivery_order
  has_many  :virtual_order_clearance_details
  validates_presence_of :virtual_delivery_order_id
  validates_presence_of :clearance_date
  
  validate :valid_virtual_delivery_order_id
  

  def valid_virtual_delivery_order_id
    return if  virtual_delivery_order_id.nil?
    vdo = VirtualDeliveryOrder.find_by_id virtual_delivery_order_id
    if vdo.nil? 
      self.errors.add(:virtual_delivery_order_id, "Harus ada VirtualDeliveryOrder Id")
      return self 
    end
  end    
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.virtual_order_clearance_details 
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.virtual_delivery_order_id = params[:virtual_delivery_order_id]
    new_object.clearance_date = params[:clearance_date]
    new_object.is_waste = params[:is_waste]
    if new_object.save  
    new_object.code = "VOC-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.virtual_order_clearance_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.virtual_delivery_order_id = params[:virtual_delivery_order_id]
    self.clearance_date = params[:clearance_date]
    self.is_waste = params[:is_waste]
    self.save
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.virtual_order_clearance_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.destroy
  end

  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.virtual_order_clearance_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    
    if self.is_waste == true 
      self.virtual_order_clearance_details.each do |vdod|
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.virtual_delivery_order.warehouse_id,:item_id => vdod.virtual_delivery_order_detail.item_id) 
      if item_in_warehouse.amount < vdod.amount
        self.errors.add(:generic_errors, "Amount #{vdod.virtual_delivery_order_detail.item.name} tidak mencukupi di gudang #{self.virtual_delivery_order.warehouse.name}")
        return self
      end
    end
    end
    
    if Closing.is_date_closed(self.clearance_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_virtual_delivery_order_confirm
      if self.total_waste_cogs > 0 
        AccountingService::CreateVirtualOrderClearanceJournal.create_confirmation_journal(self)
      end
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self  
    end
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.update_virtual_delivery_order_unconfirm
      AccountingService::CreateVirtualOrderClearanceJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
  
  def update_virtual_delivery_order_confirm 
    total_waste_cogs = 0
    self.virtual_order_clearance_details.each do |vdod|
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => vdod.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.clearance_date ,  
        :item_id => vdod.virtual_delivery_order_detail.item_id,
        :item_case => ITEM_CASE[:virtual],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      if self.is_waste == true 
        item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.virtual_delivery_order.warehouse_id,:item_id => vdod.virtual_delivery_order_detail.item_id)      
        new_stock_mutation = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => vdod.amount ,  
          :status => ADJUSTMENT_STATUS[:deduction],  
          :mutation_date => self.clearance_date ,  
          :warehouse_id => self.virtual_delivery_order.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => vdod.virtual_delivery_order_detail.item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      end
      
      if self.is_waste == true 
        vdod.virtual_delivery_order_detail.waste_amount += vdod.amount
        vdod.waste_cogs = vdod.amount * vdod.virtual_delivery_order_detail.item.avg_price
      else
        vdod.virtual_delivery_order_detail.restock_amount += vdod.amount
      end
      vdod.save
      vdod.virtual_delivery_order_detail.save
      total_waste_cogs += vdod.waste_cogs 
      self.update_virtual_delivery_order_detail_reconcile(vdod.virtual_delivery_order_detail.id)
    end
    
    self.total_waste_cogs = total_waste_cogs
    self.save
    if VirtualDeliveryOrder.find_by_id(self.virtual_delivery_order_id).virtual_delivery_order_details.where(
      :is_reconciled => false
      ).count == 0
       self.virtual_delivery_order.is_reconciled = true
       self.virtual_delivery_order.save
    end
  end
  
  def update_virtual_delivery_order_unconfirm 
    self.virtual_order_clearance_details.each do |vdod|
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => vdod.virtual_delivery_order_detail.item_id
        )
      stock_mutation.each do |sm|
        sm.reverse_stock_mutate_object  
        sm.delete_object
      end
      if self.is_waste == true 
        vdod.virtual_delivery_order_detail.waste_amount -= vdod.amount
      else
        vdod.virtual_delivery_order_detail.restock_amount -= vdod.amount
      end
      vdod.waste_cogs = 0
      vdod.virtual_delivery_order_detail.is_reconciled = false
      vdod.virtual_delivery_order_detail.save
      vdod.save
    end
    self.virtual_delivery_order.is_reconciled = false
    self.virtual_delivery_order.save
    self.total_waste_cogs = 0
    self.save
  end
  
  def update_virtual_delivery_order_detail_reconcile(virtual_delivery_order_detail_id)
    virtual_delivery_order_detail = VirtualDeliveryOrderDetail.find_by_id(virtual_delivery_order_detail_id)
    virtual_delivery_order_detail.update_is_reconcile_completed
  end
  
end
