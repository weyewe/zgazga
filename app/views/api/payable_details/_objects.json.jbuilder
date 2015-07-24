json.payable_details objects do |object|
	json.id 								object.id 
    json.payment_voucher_id 		  object.payment_voucher_id  
    json.payable_id 			 object.payable_id
    
    
    json.payment_voucher_payment_date   format_date_friendly( object.payment_voucher.payment_date ) 
    
    json.payment_voucher_no_bukti       object.payment_voucher.no_bukti
    
    
    
    json.amount 						object.amount 
    json.amount_paid 						object.amount_paid 
    json.pph_21 						object.pph_21 
    json.pph_23 						object.pph_23 
    json.rate 						object.rate 
    json.description 						object.description 
	
end
