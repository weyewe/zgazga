json.purchase_requests objects do |object|

	json.id 								object.id 
	json.request_date 			 format_date_friendly( object.request_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 					 object.nomor_surat
	
	
end
