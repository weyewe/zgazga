class Payable < ActiveRecord::Base
  belongs_to :payment_voucher
  belongs_to :exchange    
  belongs_to :contact
  has_many :payment_voucher_details 
  
  def self.active_objects
    return self
  end
  
  def source
    case self.source_class
    when PaymentRequest.to_s
      return PaymentRequest.find_by_id(self.source_id)
    when PurchaseInvoice.to_s
      return PurchaseInvoice.find_by_id(self.source_id)
    when PurchaseInvoiceMigration.to_s
      return PurchaseInvoiceMigration.find_by_id(self.source_id)
    when PurchaseDownPayment.to_s
      return PurchaseDownPayment.find_by_id(self.source_id)
    when SalesDownPayment.to_s
      return SalesDownPayment.find_by_id(self.source_id)
    when PayableMigration.to_s
      return PayableMigration.find_by_id(self.source_id)
    end
  end
  
  
  def self.create_object (params)
    new_object = self.new
    new_object.source_class = params[:source_class]
    new_object.source_id = params[:source_id]
    new_object.source_code = params[:source_code]
    new_object.source_date = params[:source_date]
    new_object.contact_id = params[:contact_id]
    new_object.amount =  BigDecimal( params[:amount] || '0')
    new_object.remaining_amount =  BigDecimal( params[:amount] || '0')
    new_object.exchange_id = params[:exchange_id]
    new_object.exchange_rate_amount =  BigDecimal( params[:exchange_rate_amount] || '0')
    new_object.due_date = params[:due_date]
    new_object.save
    return new_object
  end
  
  def update_object (params)
    self.source_class = params[:source_class]
    self.source_id = params[:source_id]
    self.source_code = params[:source_code]
    self.source_date = params[:source_date]
    self.amount = params[:amount]
    self.remaining_amount = params[:remaining_amount]
    self.save
    return self
  end
  
  def update_remaining_amount (amount)
    self.remaining_amount += amount
    self.save
    return self
  end
  
  def update_pending_clearence_amount (amount)
    self.pending_clearence_amount += amount
    self.save
    return self
  end
  
  def set_completed_payable
    if self.pending_clearence_amount == 0 and self.remaining_amount == 0 
      self.is_completed = true
    end
    if not self.pending_clearence_amount == 0 or not self.remaining_amount == 0 
      self.is_completed = false
    end
    self.save
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
  
end
