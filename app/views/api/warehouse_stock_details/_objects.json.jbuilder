json.warehouse_stock_details objects do |object|
	json.id 								object.id  
	json.item_sku			object.item.sku 
	json.item_name			object.item.name 
	
	json.amount   object.amount
	 
	
	json.item_uom_id object.item.uom.id
	json.item_uom_name object.item.uom.name 
 
end


