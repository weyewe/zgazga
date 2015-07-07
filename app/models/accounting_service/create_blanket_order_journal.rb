module AccountingService
  class CreateBlanketOrderJournal
    def CreateBlanketOrderJournal.create_finish_journal(blanket_order_detail) 
      message = "BlanketOrder Finish"
        ta = TransactionData.create_object({
          :transaction_datetime => blanket_order_detail.finished_at,
          :description =>  message,
          :transaction_source_id => blanket_order_detail.id , 
          :transaction_source_type => blanket_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal_finish],
          :is_contra_transaction => false 
        }, true )
  
      
  #      Credit Raw (RollBlanket, Bars, Adhesive), Debit FinishedGoods (Blanket)
      
      #     Debit  FinishedGoods (Blanket)
      
      total_cost  =  (blanket_order_detail.total_cost * blanket_order_detail.finished_quantity_ratio  ).round(2)
      roll_blanket_cost  =  (blanket_order_detail.manufacturing_used_roll_blanket_cost * blanket_order_detail.finished_quantity_ratio    ).round(2)
      adhesive_cost = (blanket_order_detail.adhesive_cost).round(2)
      bar_cost = total_cost - roll_blanket_cost - adhesive_cost
      
      
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:persediaan_printing_blanket][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              =>  total_cost,
        :description => "Penambahan Persediaan Blanket hasil manufacturing"
        )
  
  #     Credit Raw
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => roll_blanket_cost,
        :description => "Penggunaan roll blanket untuk manufacturing"
        )
      if blanket_order_detail.adhesive_cost > 0
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              =>  adhesive_cost,
        :description => "Penggunaan adhesive untuk manufacturing blanket"
        )
      end
      if blanket_order_detail.bar_cost > 0 
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => bar_cost,
        :description => "Penggunaan bar untuk manufacturing blanket"
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
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal_reject],
          :is_contra_transaction => false 
        }, true )
  
      
  #      Credit Raw (RollBlanket, Bars, Adhesive), Debit FinishedGoods (Blanket)
      
      #     Debit  FinishedGoods (Blanket)
      total_reject_cost  =  (blanket_order_detail.total_cost * blanket_order_detail.rejected_quantity_ratio  ).round(2)
      roll_blanket_reject_cost  =  (blanket_order_detail.manufacturing_used_roll_blanket_cost * blanket_order_detail.rejected_quantity_ratio    ).round(2)
      adhesive_cost = (blanket_order_detail.adhesive_cost).round(2)
      bar_reject_cost = total_reject_cost - roll_blanket_reject_cost - adhesive_cost
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => total_reject_cost,
        :description => "Biaya Overhead pabrik untuk manufacturing blanket REJECT"
        )
  
  #     Credit Raw
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => roll_blanket_reject_cost,
        :description => "Penggunaan Blanket untuk manufacturing blanket REJECT"
        )
        
      if blanket_order_detail.adhesive_cost > 0
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => adhesive_cost,
        :description => "Penggunaan Adhesive untuk manufacturing blanket REJECT"
        )
      end
      if blanket_order_detail.bar_cost > 0 
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => bar_reject_cost,
        :description => "Penggunaan bar untuk manufacturing blanket REJECT"
        )
      end
      
      ta.confirm
    end
    
    def CreateBlanketOrderJournal.create_defect_journal(blanket_order_detail) 
      message = "Roll Blanket Defect"
        ta = TransactionData.create_object({
          :transaction_datetime => blanket_order_detail.finished_at,
          :description =>  message,
          :transaction_source_id => blanket_order_detail.id , 
          :transaction_source_type => blanket_order_detail.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:blanket_order_detail_journal_defect],
          :is_contra_transaction => false 
        }, true )
  
 
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id     ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => blanket_order_detail.roll_blanket_defect_cost,
        :description => "Roll Blanket Defect"
        )
  
  #     Credit Raw
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:bahan_baku_blanket][:code]).id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => blanket_order_detail.roll_blanket_defect_cost,
        :description => "Roll Blanket Defect"
        )
         
      
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