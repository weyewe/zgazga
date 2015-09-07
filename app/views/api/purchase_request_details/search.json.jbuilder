
json.success true 
json.total @total
 

json.records @objects do |object|
    
    son.purchase_request_id object.purchase_request_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.name						object.name 
	json.code 			 object.code 
	json.uom 			 object.uom 
	json.description 			 object.description 
	json.category 			 object.category 
	
	if object.category == PURCHASE_CATEGORY[:penting_dan_mendesak]
		json.category_text "Penting&Mendesak"
	elsif object.category == PURCHASE_CATEGORY[:tidak_penting_dan_mendesak]
		json.category_text "TidakPenting&Mendesak"
	elsif object.category == PURCHASE_CATEGORY[:penting_dan_tidak_mendesak]
		json.category_text "Penting&TidakMendesak"
	elsif object.category == PURCHASE_CATEGORY[:tidak_penting_dan_tidak_mendesak]
		json.category_text "TidakPenting&TidakMendesak"
	end
	
	
end
