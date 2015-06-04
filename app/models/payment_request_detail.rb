class PaymentRequestDetail < ActiveRecord::Base
  
  validate :valid_payment_request
  validate :valid_account
  validate :valid_amount
  belongs_to :account
  belongs_to :payment_request
  
  def self.active_objects
    self.where(:is_deleted => false)
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_payment_request
    return if  payment_request_id.nil?
    po = PaymentRequest.find_by_id payment_request_id
    if po.nil? 
      self.errors.add(:payment_request_id, "Harus ada Purchase Invoiceid")
      return self 
    end
  end 
    
  def valid_account
    return if  account_id.nil?
    prd = Account.find_by_id account_id
    if prd.nil? 
      self.errors.add(:account_id, "Harus ada Acccount Id")
      return self 
    end
    
    itemcount = PaymentRequestDetail.where(
      :account_id => account_id,
      :payment_request_id => payment_request_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:item_id, "Account sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:item_id, "Account sudah terpakai")
      return self 
       end
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.payment_request_id = params[:payment_request_id]
    new_object.account_id = params[:account_id]
    new_object.status = params[:status]
    new_object.amount = BigDecimal( params[:amount] || '0')
    
    if new_object.save
      new_object.code = "SadjD-" + new_object.id.to_s  
      new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.payment_request.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.account_id = params[:item_id]
    self.status = params[:status]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.payment_request.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    self.calculateTotalAmount
    return self
  end
  
  
  def calculateTotalAmount
    amount = 0
    PaymentRequestDetail.where(:payment_request_id =>payment_request_id).each do |prd|
      amount += prd.amount
    end
    PaymentRequest.find_by_id(payment_request_id).update_amount(amount)
  end
end
