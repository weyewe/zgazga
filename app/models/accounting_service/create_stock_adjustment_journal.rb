module AccountingService
  class CreateStockAdjustmentJournal
  def CreateStockAdjustmentJournal.create_confirmation_journal(stock_adjustment) 
      
    message = "Stock Adjustment #{stock_adjustment.code}"

      ta = TransactionData.create_object({
        :transaction_datetime => stock_adjustment.adjustment_date,
        :description =>  message,
        :transaction_source_id => stock_adjustment.id , 
        :transaction_source_type => stock_adjustment.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:stock_adjustment_journal],
        :is_contra_transaction => false ,
      }, true )


      stock_adjustment.stock_adjustment_details.each do |sad|
        if sad.status == ADJUSTMENT_STATUS[:addition]
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => sad.item.item_type.account_id   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti         => stock_adjustment.code ,
            :description => "#{sad.item.name} #{stock_adjustment.code}"
          )
          
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:penyesuaian_modal_level_3][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti         => stock_adjustment.code ,
            :description => "#{sad.item.name} #{stock_adjustment.code}"
          ) 
        else
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => sad.item.item_type.account_id   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti         => stock_adjustment.code ,
            :description => "#{sad.item.name} #{stock_adjustment.code}"
          )
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:beban_lainnya][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti         => stock_adjustment.code ,
            :description => "#{sad.item.name} #{stock_adjustment.code}"
          ) 
        end
      end
      ta.confirm
    end

    def CreateStockAdjustmentJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:stock_adjustment_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end