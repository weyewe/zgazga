json.receivable_details objects do |object|
	json.id 								object.id 
    json.receipt_voucher_id 		  object.receipt_voucher_id  
    json.receivable_id 			 object.receivable_id
    
    
    json.receipt_voucher_receipt_date   format_date_friendly( object.receipt_voucher.receipt_date ) 
    
    json.receipt_voucher_no_bukti       object.receipt_voucher.no_bukti
    
    
    
    json.amount 						object.amount 
    json.amount_paid 						object.amount_paid 
    json.pph_23						object.pph_23
    json.rate 						object.rate 
    json.description 						object.description 
	
end
