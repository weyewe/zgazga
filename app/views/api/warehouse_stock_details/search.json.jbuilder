
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.id 								object.id  
	json.item_id 			object.item_id
	json.item_sku			object.item.sku 
	json.item_name			object.item.name 
	
	json.amount   object.amount
	json.customer_amount object.customer_amount
	
	json.item_uom_id object.item.uom.id
	json.item_uom_name object.item.uom.name 
 
	
	
end
