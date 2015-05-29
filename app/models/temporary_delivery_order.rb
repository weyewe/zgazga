class TemporaryDeliveryOrder < ActiveRecord::Base
  
  belongs_to :warehouse
  belongs_to :delivery_order
  has_many  :temporary_delivery_order_details
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.nomor_surat = params[:nomor_surat]
    new_object.order_type = params[:order_type]
    new_object.delivery_order_id = params[:delivery_order_id]
    new_object.warehouse_id = params[:warehouse_id]
    new_object.delivery_date = params[:delivery_date]
    if new_object.save  
    new_object.code = "Cadj-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.nomor_surat = params[:nomor_surat]
    self.order_type = params[:order_type]
    self.delivery_order_id = params[:delivery_order_id]
    self.warehouse_id = params[:warehouse_id]
    self.delivery_date = params[:delivery_date]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end

  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.temporary_delivery_order_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    
    
  end
  
end
