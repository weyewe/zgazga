class TemporaryDeliveryOrderDetail < ActiveRecord::Base
  
  belongs_to :warehouse
  belongs_to :temporary_delivery_order
  belongs_to :delivery_order_detail
  
  def self.active_objects
    self
  end

  def self.create_object(params)
    new_object = self.new
    new_object.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    new_object.item_id = params[:item_id]
    new_object.sales_order_detail_id = params[:sales_order_detail_id]
    if new_object.save  
    new_object.code = "Cadj-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.temporary_delivery_order_id = params[:temporary_delivery_order_id]
    self.item_id = params[:item_id]
    self.sales_order_detail_id = params[:sales_order_detail_id]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
  
end
