
json.success true 
json.total @total
 

json.records @objects do |object|
    
    
  json.unit_conversion_id 	object.unit_conversion_id 
  json.id 								object.id  
	json.amount 						object.amount 
	json.item_id                object.item.id 
	json.item_sku 			 object.item.sku 
	json.item_name 			 object.item.name
  json.item_uom_id 			 object.item.uom_id
	json.item_uom_name 			 object.item.uom.name
	
	
end
