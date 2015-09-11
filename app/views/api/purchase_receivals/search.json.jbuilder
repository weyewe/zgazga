
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.id 								object.id 
	json.receival_date 			 format_date_friendly( object.receival_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_name 			object.warehouse.name 
	json.warehouse_id 				object.warehouse.id 
	
	json.contact_id 			object.contact_id 
	json.contact_name 			object.contact.name 
	json.exchange_id 			object.exchange_id 
	json.exchange_name 			object.exchange.name 
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 			 object.nomor_surat
	
	
end
