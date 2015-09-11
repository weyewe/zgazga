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
    
    #      Debit AccountPayable, Credit Piutang Lainnya
#     Debit AccountPayable
    td = TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => purchase_down_payment_allocation.receivable.exchange.account_payable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (purchase_down_payment_allocation.total_amount   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2),
      :real_amount         => purchase_down_payment_allocation.total_amount,
      :exchange_id         => purchase_down_payment_allocation.receivable.exchange_id,
      :description => "Debit Account Payable"
      )
#     Credit Account Receivable
    td = TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => purchase_down_payment_allocation.receivable.exchange.account_receivable_id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (purchase_down_payment_allocation.total_amount   * purchase_down_payment_allocation.receivable.exchange_rate_amount).round(2),
        :real_amount         => purchase_down_payment_allocation.total_amount,
        :exchange_id         => purchase_down_payment_allocation.receivable.exchange_id,
        :description         => "Credit Account Receivable"
        )
        
    if purchase_down_payment_allocation.receivable.exchange_rate_amount < purchase_down_payment_allocation.rate_to_idr
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => ((purchase_down_payment_allocation.rate_to_idr * purchase_down_payment_allocation.total_amount) - 
                                 (purchase_down_payment_allocation.total_amount * purchase_down_payment_allocation.receivable.exchange_rate_amount) ).round(2),
        :description => "Credit ExchangeLoss"
        )     
    elsif purchase_down_payment_allocation.receivable.exchange_rate_amount > purchase_down_payment_allocation.rate_to_idr
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => ((purchase_down_payment_allocation.total_amount * purchase_down_payment_allocation.receivable.exchange_rate_amount) -
                                 (purchase_down_payment_allocation.rate_to_idr * purchase_down_payment_allocation.total_amount)).round(2),
        :description => "Debit ExchangeGain"
        ) 
    end    
    
    purchase_down_payment_allocation.purchase_down_payment_allocation_details.each do |pdpad|
      if (pdpad.rate * purchase_down_payment_allocation.rate_to_idr) > pdpad.payable.exchange_rate_amount
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => ((pdpad.amount * pdpad.rate * purchase_down_payment_allocation.rate_to_idr) -
                                   (pdpad.amount * pdpad.payable.exchange_rate_amount)).round(2),
          :description => "Debit ExchangeGain"
          ) 
      elsif (pdpad.rate * purchase_down_payment_allocation.rate_to_idr) < pdpad.payable.exchange_rate_amount
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => ((pdpad.amount * pdpad.payable.exchange_rate_amount) - 
                                   (pdpad.amount * pdpad.rate * purchase_down_payment_allocation.rate_to_idr)).round(2),
          :description => "Credit ExchangeLoss"
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