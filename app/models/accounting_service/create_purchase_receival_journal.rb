module AccountingService
  class CreatePurchaseReceivalJournal
  def CreatePurchaseReceivalJournal.create_confirmation_journal(purchase_receival) 
    message = "Purchase Receival #{purchase_receival.nomor_surat}"
      ta = TransactionData.create_object({
        :transaction_datetime => purchase_receival.receival_date,
        :description =>  message,
        :transaction_source_id => purchase_receival.id , 
        :transaction_source_type => purchase_receival.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_receival_journal],
        :is_contra_transaction => false 
      }, true )
      
#     debit raw
    total_amount = BigDecimal("0") 
    purchase_receival.purchase_receival_details.each do |prd|
      amount = BigDecimal("0")
      amount = (prd.amount * (prd.purchase_order_detail.price - prd.purchase_order_detail.discount) * purchase_receival.exchange_rate_amount).round(2)
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => prd.item.item_type.account_id    ,
        :contact_id          => purchase_receival.contact_id    ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => amount,
        :no_bukti         => purchase_receival.nomor_surat ,
        :description => "#{purchase_receival.contact.name} #{prd.item.name} #{purchase_receival.nomor_surat}"
      )
      total_amount += amount
    end
    
#     credit good pending clearance
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_pembelian_lainnya][:code]).id     ,
        :contact_id          => purchase_receival.contact_id    ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => total_amount.round(2) ,
        :no_bukti         => purchase_receival.nomor_surat ,
        :description => "#{purchase_receival.contact.name} #{purchase_receival.nomor_surat}"
      )
     ta.confirm
   
  end
    
    def CreatePurchaseReceivalJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:purchase_receival_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
  end
end