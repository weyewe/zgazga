class TemporaryDeliveryOrderClearanceDetail < ActiveRecord::Base
  
  belongs_to :temporary_delivery_order_clearance
  belongs_to :temporary_delivery_order_detail
  validate :valid_item_and_amount
  def self.active_objects
    self
  end

  def valid_item_and_amount
    return if  temporary_delivery_order_detail_id.nil?
     item = TemporaryDeliveryOrderDetail.find_by_id temporary_delivery_order_detail_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
     itemcount = TemporaryDeliveryOrderClearanceDetail.where(
       :temporary_delivery_order_detail_id => temporary_delivery_order_detail_id,
       :temporary_delivery_order_clearance => temporary_delivery_order_clearance_id,
       ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    end
    
#     check remaining sales_order_detail_amount 
    sales_order_detail = (TemporaryDeliveryOrderDetail.find_by_id temporary_delivery_order_detail_id).sales_order_detail
    total_amount_clear = 0
    TemporaryDeliveryOrderClearenceDetail.where(
        :temporary_delivery_order_detail.item_id => tdocd.item_id,
        :temporary_delivery_order_cleareance.is_confirmed == true
        ).each do |tdcd|
        total_amount_clear += tdcd.amount
    end
    if (sales_order_detail.pending_delivery_amount - total_amount_clear) < amount
      self.errors.add(:item_id, "Jumlah maksimum : " + sales_order_detail.pending_delivery_amount.to_s)
      return self 
    end
    
    
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.temporary_delivery_order_clearance_id = params[:temporary_delivery_order_clearance_id]
    new_object.temporary_delivery_order_detail_id = params[:temporary_delivery_order_detail_id]
    new_object.amount = params[:amount]
    if new_object.save  
    new_object.code = "Cadj-" + new_object.id.to_s  
#     new_object.item_id = new_object.sales_order_detail.item_id
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.temporary_delivery_order_clearance_id = params[:temporary_delivery_order_clearance_id]
    self.temporary_delivery_order_detail_id = params[:temporary_delivery_order_detail_id]
    self.amount = params[:amount]
    if self.save
#       self.item_id = self.sales_order_detail.item_id
    end
    return self
  end
  
  def delete_object
    self.destroy
  end
end
