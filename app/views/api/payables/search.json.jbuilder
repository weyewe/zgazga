
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.id 	object.id  
    json.source_class 	object.source_class  
    json.source_id 	object.source_id  
    json.source_code 	object.source_code  
    json.amount 	number_to_currency(object.amount , unit: "")
    json.remaining_amount 	number_to_currency(object.remaining_amount , unit: "") 
    json.exchange_id 	object.exchange_id  
    json.exchange_name 	object.exchange.name 
    json.exchange_rate_amount 	number_to_currency(object.exchange_rate_amount, unit: "")
    json.contact_id 	object.contact_id 
    json.contact_name	object.contact.name 
    json.due_date 	object.due_date 
    json.pending_clearence_amount 	number_to_currency(object.pending_clearence_amount, unit: "")
    json.is_completed 	object.is_completed 
	
end
