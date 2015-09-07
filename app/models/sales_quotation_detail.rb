class SalesQuotationDetail < ActiveRecord::Base
  validates_presence_of :item_id
  belongs_to :sales_quotation
  belongs_to :item
  validate :valid_sales_quotation
  validate :valid_item
  validate :valid_amount
  validate :valid_quotation_price
  
  def self.active_objects
    self
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_quotation_price
    if quotation_price < BigDecimal("0")
      self.errors.add(:quotation_price, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_sales_quotation
    return if  sales_quotation_id.nil?
    sq = SalesQuotation.find_by_id sales_quotation_id
    if sq.nil? 
      self.errors.add(:sales_quotation_id, "Harus ada SalesQuotationId")
      return self 
    end
  end 
    
  def valid_item
    return if  item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = SalesQuotationDetail.where(
      :item_id => item_id,
      :sales_quotation_id => sales_quotation_id,
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
  end 
  
  def self.create_object(params)
    new_object = self.new
    sales_quotation = SalesQuotation.find_by_id(params[:sales_quotation_id])
    if not sales_quotation.nil?
      if sales_quotation.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    
    new_object.sales_quotation_id = params[:sales_quotation_id]
    new_object.item_id = params[:item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.quotation_price = BigDecimal( params[:quotation_price] || '0')
    if new_object.save
      new_object.code = "SQD-" + new_object.id.to_s  
      new_object.rrp = new_object.item.selling_price 
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.sales_quotation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.item_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0') 
    self.quotation_price = BigDecimal( params[:quotation_price] || '0')
    if self.save
      self.rrp = self.item.selling_price 
      self.save
    end
    return self
  end
  
  def delete_object
    if self.sales_quotation.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
end
