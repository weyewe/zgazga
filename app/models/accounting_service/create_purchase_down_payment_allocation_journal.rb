module AccountingService
  class CreatePurchaseDownPaymentAllocationJournal
  def CreatePurchaseDownPaymentAllocationJournal.create_confirmation_journal(purchase_down_payment_allocation) 
    message = "Purchase Down Payment Allocation #{purchase_down_payment_allocation.code}"
    ta = TransactionData.create_object({
      :transaction_datetime => purchase_down_payment_allocation.allocation_date,
      :description =>  message,
      :transaction_source_id => purchase_down_payment_allocation.id , 
      :transaction_source_type => purchase_down_payment_allocation.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:purchase_down_payment_allocation_journal],
      :is_contra_transaction => false 
    }, true )
    
    purchase_down_payment_allocation.purchase_down_payment_allocation_details.each do |pdpad|
      amount_uang_muka = BigDecimal("0")
      amount_payable = BigDecimal("0")
      amount_uang_muka = ((pdpad.amount_paid / pdpad.rate)   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2)
      amount_payable = ((pdpad.amount_paid / pdpad.rate) * pdpad.payable.exchange_rate_amount).round(2)
      td = TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => pdpad.payable.exchange.account_payable_id  ,
        :contact_id          => purchase_down_payment_allocation.receivable.contact_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => ((pdpad.amount_paid / pdpad.rate) * pdpad.payable.exchange_rate_amount).round(2),
        :real_amount         => (pdpad.amount_paid / pdpad.rate) ,
        :exchange_id         => purchase_down_payment_allocation.receivable.exchange_id,
        :no_bukti         => purchase_down_payment_allocation.code ,
        :description => "#{purchase_down_payment_allocation.contact.name} #{purchase_down_payment_allocation.code}"
        )
      if purchase_down_payment_allocation.receivable.source.status_dp == STATUS_DP[:local]
        account_uang_muka = Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_lokal][:code])
      else
        account_uang_muka = Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_impor][:code])
      end
      td = TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => account_uang_muka.id ,
          :contact_id          => purchase_down_payment_allocation.receivable.contact_id ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => ((pdpad.amount_paid / pdpad.rate)   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2),
          :real_amount         => (pdpad.amount_paid / pdpad.rate),
          :exchange_id         => purchase_down_payment_allocation.receivable.exchange_id,
          :no_bukti         => purchase_down_payment_allocation.code ,
          :description => "#{purchase_down_payment_allocation.contact.name} #{purchase_down_payment_allocation.code}"
          )
      
      if amount_payable < amount_uang_muka
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => (amount_uang_muka - amount_payable).round(2),
          :description => "#{purchase_down_payment_allocation.contact.name} #{purchase_down_payment_allocation.code}"
          ) 
      elsif amount_payable > amount_uang_muka
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (amount_payable - amount_uang_muka).round(2),
          :description => "#{purchase_down_payment_allocation.contact.name} #{purchase_down_payment_allocation.code}"
          )    
      end
    end
    ta.confirm
  end
    
  def CreatePurchaseDownPaymentAllocationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:purchase_down_payment_allocation_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end