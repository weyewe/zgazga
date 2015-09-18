json.receipt_voucher_details objects do |object| 

	json.id 								object.id 
    json.receipt_voucher_id 		  object.receipt_voucher_id  
    json.receivable_id 			 object.receivable_id
    json.receivable_source_code			 object.receivable.source_code
    json.receivable_amount			 object.receivable.amount
    json.receivable_amount_text 					 number_to_currency(object.receivable.amount, unit: "")
    json.receivable_remaining_amount			 object.receivable.remaining_amount
    json.receivable_remaining_amount_text 					 number_to_currency(object.receivable.remaining_amount, unit: "")
    json.receivable_exchange_name			 object.receivable.exchange.name
    json.receivable_exchange_rate_amount			 object.receivable.exchange_rate_amount
    json.receivable_exchange_rate_amount_text 					 number_to_currency(object.receivable.exchange_rate_amount, unit: "")
    json.receivable_due_date			 object.receivable.due_date
    json.receivable_pending_clearence_amount			 object.receivable.pending_clearence_amount
    json.receivable_pending_clearence_amount_text 					 number_to_currency( object.receivable.pending_clearence_amount, unit: "")
    json.amount 						object.amount 
    json.amount_text  number_to_currency( object.amount, unit: "")
    json.amount_paid 						object.amount_paid 
    json.amount_paid_text  number_to_currency( object.amount_paid, unit: "")
    json.pph_23 						object.pph_23 
    json.pph_23_rate						object.pph_23_rate 
    json.pph_23_text  number_to_currency( object.pph_23, unit: "")
    json.rate 						object.rate 
    json.rate_text  number_to_currency( object.rate, unit: "")
    json.description 						object.description 
	
end
