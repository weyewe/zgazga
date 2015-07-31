 
    
json.ledgers objects do |object|

 
	json.id 				object.id  
	json.account_name       object.account.name  
	json.description        object.description 
	json.amount             object.amount
	
	if object.entry_case == NORMAL_BALANCE[:debet]
    	json.entry_case_text   "Debit" 
	else
	    json.entry_case_text   "Credit" 
	end
	
	json.created_at format_date_friendly( object.created_at )   
	
end
