class PurchaseRequest < ActiveRecord::Base
  has_many :purchase_request_details
  validates_presence_of :request_date
  validates_presence_of :nomor_surat
  
  def self.active_objects
    self
  end
  
  def active_children
    self.purchase_request_details 
  end  
  
  def self.create_object( params )
    new_object = self.new
    new_object.employee_id= params[:employee_id]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.request_date = params[:request_date]
    if new_object.save
    new_object.code = "RQ-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.purchase_request_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.employee_id= params[:employee_id]
    self.nomor_surat = params[:nomor_surat]
    self.request_date = params[:request_date]
    self.save 
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.purchase_request_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.purchase_request_details.count == 0
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
    end
    return self 
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
    end
    return self
  end
  
  
end
