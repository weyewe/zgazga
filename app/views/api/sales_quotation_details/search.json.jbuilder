
json.success true 
json.total @total
 

json.records @objects do |object|
    
    json.sales_quotation_id object.sales_quotation_id 
    
	json.id 								object.id  
	json.amount 						object.amount 
	json.quotation_price 					 object.quotation_price
	json.rrp 					 object.rrp
	json.code 			 object.code 
	
	json.item_id                object.item.id 
	json.item_sku 			 object.item.sku 
	json.item_name 			 object.item.name
	
	json.item_uom_id 			object.item.uom.id 
	json.item_uom_name 				object.item.uom.name
	
	
end
