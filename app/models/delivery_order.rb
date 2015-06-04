class DeliveryOrder < ActiveRecord::Base
  belongs_to :sales_order
  has_many :delivery_order_details
  validates_presence_of :sales_order_id
  validates_presence_of :nomor_surat
  validates_presence_of :warehouse_id
  validates_presence_of :delivery_date
  
  validate :valid_warehouse_id
  validate :valid_sales_order_id
  
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_warehouse_id
    return if  warehouse_id.nil?
    wh = Warehouse.find_by_id warehouse_id
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
      return self 
    end
  end

  def valid_sales_order_id
    return if  sales_order_id.nil?
    po = SalesOrder.find_by_id sales_order_id
    if po.nil? 
      self.errors.add(:sales_order_id, "Harus ada SalesOrder Id")
      return self 
    end
  end    
  
  def self.create_object( params )
    new_object = self.new
    new_object.warehouse_id = params[:warehouse_id]
    new_object.delivery_date = params[:delivery_date]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.sales_order_id = params[:sales_order_id]
    new_object.save
    new_object.code = "Cadj-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.delivery_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.warehouse_id = params[:warehouse_id]
    self.delivery_date = params[:delivery_date]
    self.nomor_surat = params[:nomor_surat]
    self.sales_order_id = params[:sales_order_id]
    self.save 
    return self
  end
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.delivery_order_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
#     validate warehouse_item_amount
    self.delivery_order_details.each do |dod|
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => dod.item_id)  
      if item_in_warehouse.amount < dod.amount
        self.errors.add(:generic_errors, "Amount Item tidak mencukupi")
        return self 
      end
    end
    
    if self.sales_order.exchange.is_base == false 
      latest_exchange_rate = ExchangeRate.get_latest(
        :ex_rate_date => self.delivery_date,
        :exchange_id => self.sales_order.exchange_id
        )
      self.exchange_rate_amount = latest_exchange_rate.rate
      self.exchange_rate_id =   latest_exchange_rate.id   
    else
      self.exchange_rate_amount = 1
    end
    
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_delivery_order_confirm    
      AccountingService::CreateDeliveryOrderJournal.create_confirmation_journal(self)
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
      self.update_delivery_order_unconfirm
      AccountingService::CreateDeliveryOrderJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.delivery_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def update_delivery_order_confirm
    total_cogs = 0
    total_amount = 0
    self.delivery_order_details.each do |dod|
#       Update Item PendingReceival
      
#       item_price = self.exchange_rate_amount * dod.sales_order_detail.price    
#       dod.item.calculate_avg_price(:added_amount => dod.amount,:added_avg_price => item_price)
      
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => dod.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.delivery_date ,  
        :item_id => dod.item_id,
        :item_case => ITEM_CASE[:pending_delivery],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
                 
#       Update WarehouseItem Amount
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => dod.item_id)      
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => dod.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.delivery_date ,  
        :warehouse_id => self.warehouse_id ,
        :warehouse_item_id => item_in_warehouse.id,
        :item_id => dod.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      
      dod.reload
#       set detail cogs
      dod.cogs = dod.item.avg_price * dod.amount
     
#       set detail sales_order,pending_delivery_amount
      
      if not dod.order_type == ORDER_TYPE_CASE[:part_delivery_order]
        dod.sales_order_detail.pending_delivery_amount -= dod.amount    
        if dod.sales_order_detail.pending_delivery_amount == 0 
          dod.sales_order_detail.is_all_delivered == true
        end
      end
      dod.sales_order_detail.save
      dod.save    
      total_cogs += dod.cogs
    end
    
    self.total_cogs = total_cogs
    self.save
    self.sales_order.update_is_delivery_completed
  end
  
  def update_delivery_order_unconfirm
    self.delivery_order_details.each do |dod|
      
#       amount = dod.amount * -1
#       dod.item.calculate_avg_price(:added_amount => (amount),:added_avg_price => dod.item.avg_price)
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => dod.item_id
        )
      stock_mutation.each do |sm|
        sm.reverse_stock_mutate_object  
        sm.delete_object
      end
    
#       set detail cogs
      dod.cogs = 0
#       set detail sales_order,pending_delivery_amount
      
      if not dod.order_type == ORDER_TYPE_CASE[:part_delivery_order]
        dod.sales_order_detail.pending_delivery_amount += dod.amount
        dod.sales_order_detail.is_all_delivered == false
      end
      dod.sales_order_detail.save
      dod.save
    end
    self.total_cogs = 0
    self.save
    self.sales_order.update_is_delivery_completed
  end
  
  def update_is_invoice_completed
    if self.delivery_order_details.where{(pending_invoiced_amount.gt 0)}.count == 0
      self.is_invoice_completed = true
    else
      self.is_invoice_completed = false
    end    
    self.save
  end
end