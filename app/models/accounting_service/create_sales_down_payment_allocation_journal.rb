module AccountingService
  class CreateSalesDownPaymentAllocationJournal
  def CreateSalesDownPaymentAllocationJournal.create_confirmation_journal(sales_down_payment_allocation) 
    message = "SalesDownPaymentAllocation #{sales_down_payment_allocation.code}"
      ta = TransactionData.create_object({
        :transaction_datetime => sales_down_payment_allocation.allocation_date,
        :description =>  message,
        :transaction_source_id => sales_down_payment_allocation.id , 
        :transaction_source_type => sales_down_payment_allocation.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:sales_down_payment_allocation_journal],
        :is_contra_transaction => false 
      }, true )
    
    #      Credit AccountReceivable, Debit Hutang Lain-Lain
    
#     Credit AccountReceivable
    td = TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => sales_down_payment_allocation.payable.exchange.account_receivable_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (sales_down_payment_allocation.total_amount   * sales_down_payment_allocation.payable.exchange_rate_amount).round(2),
      :real_amount         => sales_down_payment_allocation.total_amount,
      :exchange_id         => sales_down_payment_allocation.payable.exchange_id,
      :description => "Credit Account Receivable"
      )
#     Debit AccountPayable
    td = TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => sales_down_payment_allocation.payable.exchange.account_payable_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (sales_down_payment_allocation.total_amount   * sales_down_payment_allocation.payable.exchange_rate_amount).round(2),
        :real_amount         => sales_down_payment_allocation.total_amount,
        :exchange_id         => sales_down_payment_allocation.payable.exchange_id,
        :description         => "Debit Account Payable"
        )
    
   
    if sales_down_payment_allocation.payable.exchange_rate_amount < sales_down_payment_allocation.rate_to_idr
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => ((sales_down_payment_allocation.rate_to_idr * sales_down_payment_allocation.total_amount) - 
                                 (sales_down_payment_allocation.total_amount * sales_down_payment_allocation.payable.exchange_rate_amount) ).round(2),
        :description => "Credit ExchangeLoss"
        )     
    elsif sales_down_payment_allocation.payable.exchange_rate_amount > sales_down_payment_allocation.rate_to_idr
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => ((sales_down_payment_allocation.total_amount * sales_down_payment_allocation.payable.exchange_rate_amount) -
                                 (sales_down_payment_allocation.rate_to_idr * sales_down_payment_allocation.total_amount)).round(2),
        :description => "Debit ExchangeGain"
        ) 
    end  
    
    sales_down_payment_allocation.sales_down_payment_allocation_details.each do |pdpad|
      if (pdpad.rate * sales_down_payment_allocation.rate_to_idr) > pdpad.receivable.exchange_rate_amount
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => ((pdpad.amount * pdpad.rate * sales_down_payment_allocation.rate_to_idr) -
                                   (pdpad.amount * pdpad.receivable.exchange_rate_amount)).round(2),
          :description => "Debit ExchangeGain"
          ) 
      elsif (pdpad.rate * sales_down_payment_allocation.rate_to_idr) < pdpad.receivable.exchange_rate_amount
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selisih_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => ((pdpad.amount * pdpad.receivable.exchange_rate_amount) - 
                                   (pdpad.amount * pdpad.rate * sales_down_payment_allocation.rate_to_idr)).round(2),
          :description => "Credit ExchangeLoss"
          )    
      end
    end
    
    ta.confirm
  end
    
  def CreateSalesDownPaymentAllocationJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:sales_down_payment_allocation_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end
    
  end
end