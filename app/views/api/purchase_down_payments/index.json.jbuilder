
json.success true 
json.total @total
 

json.purchase_down_payments @objects do |object|
    
    
	json.id		object.id  
	json.contact_id		object.contact_id  
	json.contact_name		object.contact.name  
	json.receivable_id		object.receivable_id
	if object.receivable.nil?
		json.receivable_source_code		""
		else
		json.receivable_source_code		object.receivable.source_code
		json.receivable_remaining_amount object.receivable.remaining_amount
	end
	json.payable_id		object.payable_id
	if object.payable.nil?
		json.payable_source_code ""
		else
		json.payable_source_code		object.payable.source_code
	end
	json.status_dp object.status_dp
	if object.status_dp == STATUS_DP[:local]
		json.status_dp_text "Local"
		else
		json.status_dp_text "Import"
	end
	json.code		object.code
	json.down_payment_date	format_date_friendly( 	object.down_payment_date ) 
	json.due_date	format_date_friendly( 	object.due_date ) 
	json.exchange_id		object.exchange_id
	json.exchange_name		object.exchange.name
	json.exchange_rate_id		object.exchange_rate_id
	json.exchange_rate_amount		object.exchange_rate_amount
	json.total_amount		object.total_amount
	json.is_confirmed		object.is_confirmed
	json.confirmed_at 	format_date_friendly( 	object.confirmed_at ) 
	
end
