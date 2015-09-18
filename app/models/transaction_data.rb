class TransactionData < ActiveRecord::Base
  # belongs_to :transaction_data_non_base_exchange_details
  has_many :transaction_data_details 
  validates_presence_of :transaction_datetime 
  
  
  def self.active_objects
    self
  end
  
  def source 
    case self.transaction_source_type
    when BankAdministration.to_s
      return BankAdministration.find_by_id(self.transaction_source_id)
    when BlanketOrderDetail.to_s
      return BlanketOrderDetail.find_by_id(self.transaction_source_id)
    when BlendingWorkOrder.to_s
      return BlendingWorkOrder.find_by_id(self.transaction_source_id)
    when CashBankAdjustment.to_s
      return CashBankAdjustment.find_by_id(self.transaction_source_id)
    when CashBankMutation.to_s
      return CashBankMutation.find_by_id(self.transaction_source_id)
    when DeliveryOrder.to_s
      return DeliveryOrder.find_by_id(self.transaction_source_id)
    when Memorial.to_s
      return Memorial.find_by_id(self.transaction_source_id)
    when PayableMigration.to_s
      return PayableMigration.find_by_id(self.transaction_source_id)
    when PaymentRequest.to_s
      return PaymentRequest.find_by_id(self.transaction_source_id)
    when PaymentVoucher.to_s
      return PaymentVoucher.find_by_id(self.transaction_source_id)
    when PurchaseDownPaymentAllocation.to_s
      return PurchaseDownPaymentAllocation.find_by_id(self.transaction_source_id)
    when PurchaseDownPayment.to_s
      return PurchaseDownPayment.find_by_id(self.transaction_source_id)
    when PurchaseInvoice.to_s
      return PurchaseInvoice.find_by_id(self.transaction_source_id)
    when PurchaseInvoiceMigration.to_s
      return PurchaseInvoiceMigration.find_by_id(self.transaction_source_id)
    when PurchaseReceival.to_s
      return PurchaseReceival.find_by_id(self.transaction_source_id)  
    when ReceiptVoucher.to_s
      return ReceiptVoucher.find_by_id(self.transaction_source_id)
    when ReceivableMigration.to_s
      return ReceivableMigration.find_by_id(self.transaction_source_id)
    when RecoveryOrder.to_s
      return RecoveryOrder.find_by_id(self.transaction_source_id)  
    when SalesDownPaymentAllocation.to_s
      return SalesDownPaymentAllocation.find_by_id(self.transaction_source_id)
    when SalesDownPayment.to_s
      return SalesDownPayment.find_by_id(self.transaction_source_id)
    when SalesInvoice.to_s
      return SalesInvoice.find_by_id(self.transaction_source_id)
    when SalesInvoiceMigration.to_s
      return SalesInvoiceMigration.find_by_id(self.transaction_source_id)
    when UnitConversionOrder.to_s
      return UnitConversionOrder.find_by_id(self.transaction_source_id)
    when VirtualOrderClearance.to_s
      return VirtualOrderClearance.find_by_id(self.transaction_source_id)
    end
  end
  
  
  def self.create_object( params, is_automated_transaction ) 
    new_object = self.new 
    new_object.transaction_datetime = params[:transaction_datetime]
    new_object.description = params[:description]
    new_object.code = params[:code]
    if is_automated_transaction
      new_object.transaction_source_id = params[:transaction_source_id]
      new_object.transaction_source_type = params[:transaction_source_type]
    end
    
    if new_object.save
      # if not params[:exchange_id].nil?
      #   if(Exchange.find_by_id params[:exchange_id]).is_base == false
      #     TransactionDataNonBaseExchange.create_object(
      #       :transaction_data_id => new_object.id,
      #     )
      #   end
      # end
    end
    return new_object
  end
   
  def update_affected_accounts_due_to_confirmation
    # self.transaction_data_details.each do |ta_entry|
    #   account = ta_entry.account 
    #   account.update_amount_from_posting_confirm(ta_entry)
    # end
  end
  
  def update_affected_accounts_due_to_un_confirmation
    self.transaction_data_details.each do |ta_entry|
      account = ta_entry.account 
      account.update_amount_from_posting_unconfirm(ta_entry)
    end
  end
  
  def confirm
    if self.transaction_data_details.count == 0 
      self.errors.add(:generic_errors, "Tidak ada posting. Tidak bisa konfirmasi")
      return self
    end
    
    if self.total_debit != self.total_credit
      self.errors.add(:generic_errors, "Total debit (#{total_debit}) tidak sama dengan total credit (#{total_credit})")
      return self 
    end
    
    if self.total_debit == BigDecimal('0')  
      self.errors.add(:generic_errors, "Total jumlah transaksi tidak boleh 0")
      return self 
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah dikonfirmasi")
      return self 
    end
    
    self.is_confirmed = true
    self.amount = self.total_credit 
    if self.save 
      self.update_affected_accounts_due_to_confirmation
    end
  end
  
  
  # to be called in the controller 
  def external_unconfirm
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    self.is_confirmed = false 
    if self.save
      self.update_affected_accounts_due_to_un_confirmation
    end
  end
  
  def unconfirm
    self.is_confirmed = false 
    if self.save
      self.update_affected_accounts_due_to_un_confirmation
    end
  end
  
  def total_debit
    self.transaction_data_details.where(:entry_case => NORMAL_BALANCE[:debit]).sum("amount")
  end
  
  
  
  def total_credit
    self.transaction_data_details.where(:entry_case => NORMAL_BALANCE[:credit]).sum("amount")
  end 
  
  # can only be called from the business rule 
  
  def internal_object_update(params)
  end
  
  def internal_object_destroy
  end
  
  def delete_object
    self.destroy
  end
   
  def create_contra_and_confirm
    new_object = self.class.new 
    
    new_object.transaction_datetime = self.transaction_datetime
    new_object.description =  "[contra posting at #{DateTime.now}]" + self.description
    new_object.code = self.code 
    
    new_object.transaction_source_id = self.transaction_source_id
    new_object.transaction_source_type = self.transaction_source_type
    new_object.is_contra_transaction = true 
    new_object.save 
    
    self.transaction_data_details.each do |tdd|
      tdd.create_contra(new_object)
    end
    new_object.confirm 
  end
  
  def active_children
    self.transaction_data_details
  end
end
