module AccountingService
  class CreatePaymentRequestJournal
  def CreatePaymentRequestJournal.create_confirmation_journal(payment_request) 
    message = "Payment Request #{payment_request.no_bukti}"
      ta = TransactionData.create_object({
        :transaction_datetime => payment_request.request_date,
        :description =>  message,
        :transaction_source_id => payment_request.id , 
        :transaction_source_type => payment_request.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payment_request_journal],
        :is_contra_transaction => false,
      }, true )

    
#      Credit AccountPayable, Debit Account User Input
    
#     Credit AccountPayable
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => payment_request.account_id  ,
      :contact_id          => payment_request.contact_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (payment_request.amount * payment_request.exchange_rate_amount).round(2),
      :real_amount         => payment_request.amount ,
      :exchange_id         => payment_request.exchange_id ,
      :no_bukti         => payment_request.no_bukti ,
      :description => "#{payment_request.contact.name}  #{payment_request.no_bukti}"
      )

#     Debit Account User Input
    payment_request.payment_request_details.each do |prd|
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => prd.account_id ,
        :contact_id          => payment_request.contact_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (prd.amount * payment_request.exchange_rate_amount).round(2),
        :no_bukti         => payment_request.no_bukti ,
        :description => "#{payment_request.contact.name}  #{payment_request.no_bukti} #{prd.description}"
      )
    end
    ta.confirm
  end
    
    def CreatePaymentRequestJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payment_request_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end