
json.success true 
json.total @total
 

json.records @objects do |object|
    
     json.purchase_order_id object.purchase_order_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.pending_receival_amount 						object.pending_receival_amount 
	json.price 					 object.price
		json.discount 					 object.discount
	json.code 			 object.code 
	json.purchase_order_code               object.purchase_order.code 
	json.purchase_order_nomor_surat               object.purchase_order.nomor_surat 
	json.item_id                object.item.id 
	json.item_sku 			 object.item.sku 
	json.item_name 			 object.item.name
		json.is_all_received 			 object.is_all_received
	json.item_uom_id 			object.item.uom.id 
	json.item_uom_name 				object.item.uom.name
	
 
	
	
end
