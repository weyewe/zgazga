module AccountingService
  class CreatePayableMigrationJournal
      
      
  def self.create_confirmation_journal(payable_migration) 
    message = "Payable Migration #{payable_migration.nomor_surat}"
      ta = TransactionData.create_object({
        :transaction_datetime => payable_migration.invoice_date,
        :description =>  message,
        :transaction_source_id => payable_migration.id , 
        :transaction_source_type => payable_migration.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payable_migration_journal],
        :is_contra_transaction => false 
      }, true )
    
 
    TransactionDataDetail.create_object(
      :transaction_data_id => ta.id,        
      :account_id          => payable_migration.exchange.account_payable_id  ,
      :contact_id          => payable_migration.contact_id  ,
      :entry_case          => NORMAL_BALANCE[:credit]     ,
      :amount              => (payable_migration.amount_payable   * payable_migration.exchange_rate_amount).round(2),
      :real_amount         => payable_migration.amount_payable,
      :exchange_id         => payable_migration.exchange_id,
      :no_bukti            => payable_migration.nomor_surat,
      :description => "#{payable_migration.contact.name} #{payable_migration.nomor_surat}"
      )
    
    TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:penyesuaian_modal_level_3][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (payable_migration.amount_payable   * payable_migration.exchange_rate_amount).round(2),
        # :real_amount         => payable_migration.amount_payable,
        :exchange_id         => payable_migration.exchange_id,
        :no_bukti            => payable_migration.nomor_surat,
        :description => "#{payable_migration.contact.name} #{payable_migration.nomor_surat}"
        )
    ta.confirm
  end
 
    
  end
end