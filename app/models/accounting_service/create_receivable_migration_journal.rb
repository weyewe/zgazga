module AccountingService
  class CreateReceivableMigrationJournal
      
      
  def self.create_confirmation_journal(receivable_migration) 
    message = "Receivable Migration"
      ta = TransactionData.create_object({
        :transaction_datetime => receivable_migration.invoice_date,
        :description =>  message,
        :transaction_source_id => receivable_migration.id , 
        :transaction_source_type => receivable_migration.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:receivable_migration_journal],
        :is_contra_transaction => false 
      }, true )
      
    
    if receivable_migration.exchange.is_base?
      real_amount = nil
    else
      real_amount =  receivable_migration.amount_receivable
    end
    
    # puts "The real amount: #{real_amount.to_s}, exchange: #{receivable_migration.exchange.is_base}"
 
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => receivable_migration.exchange.account_receivable_id  ,
      :entry_case          => NORMAL_BALANCE[:debit]     ,
      :amount              => (receivable_migration.amount_receivable   * receivable_migration.exchange_rate_amount).round(2),
      :real_amount         => real_amount,
      :exchange_id         => receivable_migration.exchange_id,
      :description => "Debit Account Receivable"
      )
    
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:penyesuaian_modal_level_3][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (receivable_migration.amount_receivable   * receivable_migration.exchange_rate_amount).round(2),
        # :real_amount         => receivable_migration.amount_receivable,
        :exchange_id         => receivable_migration.exchange_id,
        
        
        :description         => "Credit Penyesuaian Modal"
        )
    ta.confirm
  end
 
    
  end
end