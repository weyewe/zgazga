
json.success true 
json.total @total
 

json.blanket_warehouse_mutation_details @objects do |object|
    
    json.blanket_warehouse_mutation_id 	object.blanket_warehouse_mutation_id 
	json.id 	object.id  
	json.blanket_order_detail_id	object.blanket_order_detail_id  
	json.code	object.code  
	json.item_id	object.item_id  
	json.item_sku	object.item.sku  
	json.item_name	object.item.name  
	json.quantity	object.quantity  
	
end
