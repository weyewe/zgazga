json.transaction_data_details objects do |object|

 
    
	json.id 								object.id    
	json.transaction_data_id 			    object.transaction_data_id
	
	json.account_name 			            object.account.name 
	json.account_code 			            object.account.code 
	
	if object.entry_case == NORMAL_BALANCE[:debit]
    	json.entry_case_text   "Debit" 
	else
	    json.entry_case_text   "Credit" 
	end
	 
	json.amount                     object.amount 
	json.description                object.description
	json.is_bank_transaction        object.is_bank_transaction 
	
	
end
