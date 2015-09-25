module AccountingService
  class CreateCustomerStockAdjustmentJournal
  def CreateCustomerStockAdjustmentJournal.create_confirmation_journal(customer_stock_adjustment) 
      
    message = "Stock Adjustment #{customer_stock_adjustment.code}"

      ta = TransactionData.create_object({
        :transaction_datetime => customer_stock_adjustment.adjustment_date,
        :description =>  message,
        :transaction_source_id => customer_stock_adjustment.id , 
        :transaction_source_type => customer_stock_adjustment.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:customer_stock_adjustment_journal],
        :is_contra_transaction => false ,
      }, true )


      customer_stock_adjustment.customer_stock_adjustment_details.each do |sad|
        if sad.status == ADJUSTMENT_STATUS[:addition]
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => sad.item.item_type.account_id   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti            => customer_stock_adjustment.code,
            :description => "#{customer_stock_adjustment.code}  #{sad.item.name}"
          )
          
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:penyesuaian_modal_level_3][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti            => customer_stock_adjustment.code,
            :description => "#{customer_stock_adjustment.code}  #{sad.item.name}"
          ) 
        else
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => sad.item.item_type.account_id   ,
            :entry_case          => NORMAL_BALANCE[:credit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
             :no_bukti            => customer_stock_adjustment.code,
            :description => "#{customer_stock_adjustment.code}  #{sad.item.name}"
          )
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => Account.find_by_code(ACCOUNT_CODE[:beban_lainnya][:code]).id        ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => (sad.amount * sad.price).round(2) ,
            :no_bukti            => customer_stock_adjustment.code,
            :description => "#{customer_stock_adjustment.code}  #{sad.item.name}"
          ) 
        end
      end
      ta.confirm
  end

    def CreateCustomerStockAdjustmentJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:customer_stock_adjustment_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end

  end
end