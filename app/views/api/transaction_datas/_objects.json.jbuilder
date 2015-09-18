json.transaction_datas objects do |object|

 
    
	json.id 								object.id 
	json.transaction_datetime 			 format_date_friendly( object.transaction_datetime )   
	json.transaction_source_id 			 object.transaction_source_id 
	json.transaction_source_type 			object.transaction_source_type
	json.description 				object.description
	json.amount 				number_to_currency(object.amount, unit: "")
	json.is_contra_transaction 				object.is_contra_transaction
	
	json.code 				object.code 
	
	
end
