module AccountingService
  class CreateBankAdministrationJournal
  def CreateBankAdministrationJournal.create_confirmation_journal(bank_administration) 
      
    message = "BankAdministration #{bank_administration.no_bukti} "

      ta = TransactionData.create_object({
        :transaction_datetime => bank_administration.administration_date,
        :description =>  message,
        :transaction_source_id => bank_administration.id , 
        :transaction_source_type => bank_administration.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:bank_administration_journal],
        :is_contra_transaction => false ,
      }, true )
      
      # Credit/Debit CashBank, Debit/Credit User Input
      
      status = NORMAL_BALANCE[:debit]
      status_text = "Debet"
      amount = bank_administration.amount
      if bank_administration.amount < 0 
        amount = bank_administration.amount * -1
        status = NORMAL_BALANCE[:credit]
        status_text = "Credit"
      end
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => bank_administration.cash_bank.account_id     ,
        :entry_case          => status ,
        :amount              => (amount * bank_administration.exchange_rate_amount).round(2) ,
        :real_amount         => amount ,
        :exchange_id         => bank_administration.cash_bank.exchange_id ,
        :no_bukti         => bank_administration.no_bukti ,
        :description => "#{no_bukti}"
      )
      bank_administration.bank_administration_details.each do |bad|
        status_text = "Debet"
        if bad.status == NORMAL_BALANCE[:credit]
          status_text = "Credit"
        end
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => bad.account_id       ,
          :entry_case          => bad.status     ,
          :amount              => (bad.amount * bank_administration.exchange_rate_amount).round(2),
          :no_bukti         => bank_administration.no_bukti ,
          :description => "#{no_bukti}"
        )
      end
      ta.confirm
    end

    def CreateBankAdministrationJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:bank_administration_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end