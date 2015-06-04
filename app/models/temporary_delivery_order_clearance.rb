class TemporaryDeliveryOrderClearance < ActiveRecord::Base
 
  
  belongs_to :temporary_delivery_order
  has_many  :temporary_delivery_order_clearance_details
  validates_presence_of :temporary_delivery_order_id
  validates_presence_of :clearance_date
  
  validate :valid_temporary_delivery_order_id
  
  def valid_temporary_delivery_order_id
    return if  temporary_delivery_order_id.nil?
    tdo = TemporaryDeliveryOrder.find_by_id temporary_delivery_order_id
    if tdo.nil? 
      self.errors.add(:temporary_delivery_order_id, "Harus ada Temporary Delivery Order Id")
      return self 
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    new_object.clearance_date = params[:clearance_date]
    if new_object.save  
    new_object.code = "Cadj-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
     if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.temporary_delivery_order_clearance_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    self.clearance_date = params[:clearance_date]
    self.save
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.temporary_delivery_order_clearance_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.destroy
    return self
  end

  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.temporary_delivery_order_clearance_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_temporary_delivery_order_clearance_confirm
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
      self.update_temporary_delivery_order_clearance_unconfirm
    end
    return self
  end
  
  def update_temporary_delivery_order_clearance_confirm 
    total_cogs = 0
    self.temporary_delivery_order_clearance_details.each do |tdocd|
#       reduce virtual amount
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => tdocd.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.clearance_date ,  
        :item_id => tdocd.item_id,
        :item_case => ITEM_CASE[:virtual],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      
#       reduce ready amount
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => tdocd.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.clearance_date ,  
        :item_id => tdocd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      tdocd.save
    end
      #      Checked TemporaryDeliveryOrder are Full Clearance
    self.temporary_delivery_order_clearance_details.each do |tdocd|
      sales_order_detail = tdocd.temporary_delivery_order_detail.sales_order_detail
      total_amount_clear = 0
      TemporaryDeliveryOrderClearenceDetail.where(
        :temporary_delivery_order_detail.item_id => tdocd.item_id,
        :temporary_delivery_order_cleareance.is_confirmed => true
        ).each do |tdcd|
        total_amount_clear += tdcd.amount
      end
      if sales_order_detail.pending_delivery_amount == total_amount_clear
        DeliveryOrderDetail.create_object(
          :delivery_order_id => self.temporary_delivery_order.delivery_order_id,
          :sales_order_detail_id => sales_order_detail.id,
          :amount => sales_order_detail.pending_delivery_amount,
          :order_type => ORDER_TYPE_CASE[:part_delivery_order]
          )
      end
    end
  end
  
  def update_temporary_delivery_order_clearance_unconfirm 
    self.temporary_delivery_order_clearance_details.each do |tdocd|
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => tdocd.item_id
        )
      stock_mutation.each do |sm|
        sm.reverse_stock_mutate_object  
        sm.delete_object
      end
      tdod.sales_order_detail.pending_delivery_amount += tdod.amount
      tdod.sales_order_detail.is_all_delivered == false
      tdod.sales_order_detail.save
    end
  end  
  
end
