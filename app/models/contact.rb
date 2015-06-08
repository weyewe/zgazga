class Contact < ActiveRecord::Base
  validates_presence_of :name 
  
  def self.customers
    self.where(:customer_type => CONTACT_TYPE[:customer])
  end
  
  def self.suppliers
    self.where(:customer_type => CONTACT_TYPE[:supplier] )
  end
  
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.address = params[:address]
    new_object.delivery_address = params[:delivery_address]
    new_object.description = params[:description]
    new_object.npwp = params[:npwp]
    new_object.contact_no = params[:contact_no]
    new_object.pic = params[:pic]
    new_object.pic_contact_no = params[:pic_contact_no]
    new_object.email = params[:email]
    new_object.is_taxable = params[:is_taxable]
    new_object.tax_code = params[:tax_code]
    new_object.contact_type = params[:contact_type]
    new_object.default_payment_term = params[:default_payment_term]
    new_object.nama_faktur_pajak = params[:nama_faktur_pajak]
    new_object.contact_group_id = params[:contact_group_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.address = params[:address]
    self.delivery_address = params[:delivery_address]
    self.description = params[:description]
    self.npwp = params[:npwp]
    self.contact_no = params[:contact_no]
    self.pic = params[:pic]
    self.pic_contact_no = params[:pic_contact_no]
    self.email = params[:email]
    self.is_taxable = params[:is_taxable]
    self.tax_code = params[:tax_code]
    self.contact_type = params[:contact_type]
    self.default_payment_term = params[:default_payment_term]
    self.nama_faktur_pajak = params[:nama_faktur_pajak]
    self.contact_group_id = params[:contact_group_id]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
end
