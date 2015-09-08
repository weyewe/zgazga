module AccountingService
  class CreateUnitConversionOrderJournal
  def CreateUnitConversionOrderJournal.create_confirmation_journal(unit_conversion_order,total_cost) 
      
    message = "UnitConversionOrder #{unit_conversion_order.code}"

      ta = TransactionData.create_object({
        :transaction_datetime => unit_conversion_order.conversion_date,
        :description =>  message,
        :transaction_source_id => unit_conversion_order.id , 
        :transaction_source_type => unit_conversion_order.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:unit_conversion_order_journal],
        :is_contra_transaction => false ,
      }, true )
        
      # Credit Raw (Source Items), Debit FinishedGoods (Chemical), Debit BlendingExpense (2%)
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => unit_conversion_order.unit_conversion.target_item.item_type.account_id    ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => total_cost ,
        :description => "Debit FinishedGoods"
      )

      # TransactionDataDetail.create_object(
      #   :transaction_data_id => ta.id,        
      #   :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_overhead_pabrik_level_3][:code]).id        ,
      #   :entry_case          => NORMAL_BALANCE[:debit]     ,
      #   :amount              => (total_cost * 2 / 100).round(2),
      #   :description => "Debit Blending Expense"
      # )
      
      unit_conversion_order.unit_conversion.unit_conversion_details.each do |brd|
        TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => brd.item.item_type.account_id,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (brd.amount * brd.item.avg_price).round(2),
        :description => "Credit Inventory"
        )
      end
      ta.confirm
  end

  def CreateUnitConversionOrderJournal.undo_create_confirmation_journal(object)
    last_transaction_data = TransactionData.where(
      :transaction_source_id => object.id , 
      :transaction_source_type => object.class.to_s ,
      :code => TRANSACTION_DATA_CODE[:unit_conversion_order_journal],
      :is_contra_transaction => false
    ).order("id DESC").first 
    last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
  end

  end
end