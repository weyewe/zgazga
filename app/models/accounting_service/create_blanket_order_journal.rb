module AccountingService
  class CreateBlanketOrderJournal
    def CreateBlanketOrderJournal.create_finish_journal(blanket_order_detail) 
      message = "BlanketOrder Finish"
        ta = TransactionData.create_object({
          :transaction_datetime => blanket_order_detail.finished_at,
          :description =>  message,
          :transaction_source_id => blanket_order_detail.id , 
          :transaction_source_type => blanket_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal],
          :is_contra_transaction => false 
        }, true )
  
      
  #      Credit Raw (RollBlanket, Bars, Adhesive), Debit FinishedGoods (Blanket)
      
      #     Debit  FinishedGoods (Blanket)
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_blanket][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (blanket_order_detail.total_cost).round(2),
        :description => "Debit COGS"
        )
  
  #     Credit Raw
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.roll_blanket_cost).round(2),
        :description => "Credit RollBlanket"
        )
      if blanket_order_detail.adhesive_cost > 0
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.adhesive_cost).round(2),
        :description => "Credit RollBlanket"
        )
      end
      if blanket_order_detail.bar_cost > 0 
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.bar_cost).round(2),
        :description => "Credit RollBlanket"
        )
      end
      
      ta.confirm
    end
    
    def CreateBlanketOrderJournal.create_reject_journal(blanket_order_detail) 
      message = "BlanketOrder Reject"
        ta = TransactionData.create_object({
          :transaction_datetime => blanket_order_detail.finished_at,
          :description =>  message,
          :transaction_source_id => blanket_order_detail.id , 
          :transaction_source_type => blanket_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal],
          :is_contra_transaction => false 
        }, true )
  
      
  #      Credit Raw (RollBlanket, Bars, Adhesive), Debit FinishedGoods (Blanket)
      
      #     Debit  FinishedGoods (Blanket)
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (blanket_order_detail.total_cost).round(2),
        :description => "Debit COGS"
        )
  
  #     Credit Raw
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.roll_blanket_cost).round(2),
        :description => "Credit RollBlanket"
        )
      if blanket_order_detail.adhesive_cost > 0
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.adhesive_cost).round(2),
        :description => "Credit RollBlanket"
        )
      end
      if blanket_order_detail.bar_cost > 0 
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (blanket_order_detail.bar_cost).round(2),
        :description => "Credit RollBlanket"
        )
      end
      
      ta.confirm
    end
    
    
    def CreateBlanketOrderJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
  end
end