class VirtualDeliveryOrderDetail < ActiveRecord::Base
    
  belongs_to :virtual_delivery_order
  belongs_to :virtual_order_detail
  belongs_to :item
  validate :valid_delivery_order
  validate :valid_virtual_order_detail
  
  def self.active_objects
    self
  end
  
  def valid_delivery_order
    return if  virtual_delivery_order_id.nil?
    pr = VirtualDeliveryOrder.find_by_id virtual_delivery_order_id
    if pr.nil? 
      self.errors.add(:virtual_delivery_order_id, "Harus ada virtual_delivery_order_id")
      return self 
    end
  end 
  
  
  def valid_virtual_order_detail
    return if  virtual_order_detail_id.nil?
    pod = VirtualDeliveryOrderDetail.find_by_id virtual_order_detail_id
    if pod.nil? 
      self.errors.add(:virtual_order_detail_id, "Harus ada virtual_order_detail_id")
      return self 
    end
    
    itemcount = VirtualDeliveryOrderDetail.where(
      :virtual_order_detail_id => virtual_order_detail_id,
      :virtual_delivery_order_id => virtual_delivery_order_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:virtual_order_detail_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:virtual_order_detail_id, "Item sudah terpakai")
      return self 
       end
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.virtual_delivery_order_id = params[:virtual_delivery_order_id]
    new_object.virtual_order_detail_id = params[:virtual_order_detail_id]
    new_object.amount = params[:amount]
    if new_object.save  
    new_object.code = "Vdo-d" + new_object.id.to_s  
    new_object.item_id = new_object.virtual_order_detail.item_id
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.virtual_delivery_order_id = params[:virtual_delivery_order_id]
    self.virtual_order_detail_id = params[:virtual_order_detail_id]
    self.amount = params[:amount]
    if self.save
      self.item_id = self.virtual_order_detail.item_id
    end
    return self
  end
  
  def delete_object
    self.destroy
  end
  
end
