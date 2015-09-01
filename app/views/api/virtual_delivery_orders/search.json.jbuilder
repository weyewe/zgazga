
json.success true 
json.total @total
 

json.records @objects do |object|
    
   	json.id 								object.id 
	json.delivery_date 			 format_date_friendly( object.delivery_date )   
	json.is_confirmed 			 object.is_confirmed
	
	json.warehouse_name 			object.warehouse.name 
	json.warehouse_id 				object.warehouse.id 
	
	json.virtual_order_code 			object.virtual_order.code 
	json.virtual_order_nomor_surat 			object.virtual_order.nomor_surat 
	json.virtual_order_id 				object.virtual_order.id 
	json.virtual_order_contact_name				object.virtual_order.contact.name
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
 	json.nomor_surat 			 object.nomor_surat
	
end
