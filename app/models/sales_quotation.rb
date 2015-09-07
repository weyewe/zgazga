class SalesQuotation < ActiveRecord::Base
  belongs_to :contact
  has_many :sales_quotation_details
  validates_presence_of :quotation_date
  validates_presence_of :nomor_surat
  validates_presence_of :version_no
  validates_presence_of :contact_id
  validate :valid_contact_id
  
  def self.active_objects
    self
  end
  
  def active_children
    self.sales_quotation_details 
  end
  
  def valid_contact_id
    return if contact_id.nil?
    
    co = Contact.find_by_id contact_id
    
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
      return self 
    end
  end
  
  def self.create_object( params )
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.version_no = params[:version_no]
    new_object.description = params[:description]
    new_object.quotation_date = params[:quotation_date]
    if new_object.save
    new_object.code = "SQ-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.sales_quotation_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.contact_id = params[:contact_id]
    self.nomor_surat = params[:nomor_surat]
    self.version_no = params[:version_no]
    self.description = params[:description]
    self.quotation_date = params[:quotation_date]
    self.save 
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.sales_quotation_details.count > 0
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
    
    if self.sales_quotation_details.count == 0
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
      self.update_sales_quotation_confirm    
    end
    return self 
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self 
    end
    if self.is_approved?
      self.errors.add(:generic_errors, "Sudah di approve")
      return self 
    end
    if self.is_rejected?
      self.errors.add(:generic_errors, "Sudah di reject")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.update_sales_quotation_unconfirm
    end
    return self
  end
  
  def approve_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self 
    end
    if self.is_rejected?
      self.errors.add(:generic_errors, "Sudah di reject")
      return self 
    end
    self.is_approved = true
    self.save
    return self
  end
  
  def reject_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Belum di konfirmasi")
      return self 
    end
    if self.is_approved?
      self.errors.add(:generic_errors, "Sudah di approve")
      return self 
    end
    self.is_rejected = true
    self.save
    return self
  end
  
  def update_sales_quotation_confirm
    total_quote = BigDecimal('0')
    total_rrp = BigDecimal('0')
    total_cost_saved = BigDecimal('0')
    total_percentage_saved = BigDecimal('0')
    self.sales_quotation_details.each do |sqd|
      total_quote = total_quote + (sqd.amount * sqd.quotation_price)
      total_rrp = total_rrp + (sqd.amount * sqd.rrp)
    end
    total_cost_saved = total_rrp - total_quote
    if total_cost_saved < 0
      total_cost_saved = 0
    end
    if not (total_cost_saved == 0 or total_rrp == 0)
      total_percentage_saved = total_cost_saved / total_rrp * 100      
    end
    self.total_quote_amount = total_quote
    self.total_rrp_amount = total_rrp 
  
    self.cost_saved = total_cost_saved
    self.percentage_saved = total_percentage_saved
    self.save
  end
  
  def update_sales_quotation_unconfirm
    self.total_quote_amount = 0
    self.total_rrp_amount = 0 
    self.cost_saved = 0
    self.percentage_saved = 0
    self.save
  end
  
end
