json.receipt_vouchers objects do |object|

  json.id 								object.id 
  json.receipt_date 			 format_date_friendly( object.receipt_date )   
	json.no_bukti 			 object.no_bukti
	json.no_voucher 			 object.no_voucher
  json.contact_id 			 object.contact_id
  json.contact_name 			 object.contact.name
  json.cash_bank_id 			 object.cash_bank_id
  json.cash_bank_name 			 object.cash_bank.name
  json.cash_bank_exchange_name 			 object.cash_bank.exchange.name
	json.is_confirmed 			 object.is_confirmed
	json.is_reconciled 			 object.is_reconciled
	json.gbch_no 			 object.gbch_no
	json.is_gbch 			 object.is_gbch
	json.due_date 			format_date_friendly(  object.due_date ) 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	json.reconciliation_date 						format_date_friendly( 	object.reconciliation_date ) 
	
	json.code 					 object.code
	json.amount 					 object.amount
	json.amount_text 					 number_to_currency(object.amount, unit: "")  
	json.rate_to_idr 					 object.rate_to_idr
	json.rate_to_idr_text					 number_to_currency(object.rate_to_idr, unit: "")  
	json.biaya_bank 					 object.biaya_bank
	json.pembulatan 					 object.pembulatan
	json.pembulatan_text 					 number_to_currency(object.pembulatan, unit: "")
	
	json.total_pph_23 					 object.total_pph_23
	json.total_pph_23_text 					 number_to_currency(object.total_pph_23, unit: "")
	json.status_pembulatan 					 object.status_pembulatan
	if object.status_pembulatan == 1
		json.status_pembulatan_text  "Debet"
	else
		json.status_pembulatan_text  "Credit"
	end


	
end


