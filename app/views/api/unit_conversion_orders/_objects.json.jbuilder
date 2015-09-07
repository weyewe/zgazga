
json.unit_conversion_orders objects do |object|

	json.id 	object.id 
	json.code 	object.code 
	json.description 	object.description 
	json.unit_conversion_id 	object.unit_conversion_id 
	json.unit_conversion_name 	object.unit_conversion.name 
	json.unit_conversion_target_item_sku 	object.unit_conversion.target_item.sku 
	json.unit_conversion_target_item_name 	object.unit_conversion.target_item.name 
	json.unit_conversion_target_item_uom_name 	object.unit_conversion.target_item.uom.name 
	json.unit_conversion_target_amount 	object.unit_conversion.target_amount 
	json.conversion_date  format_date_friendly( object.conversion_date )
	json.warehouse_id  object.warehouse_id
	json.warehouse_name  object.warehouse.name
	json.confirmed_at  		format_date_friendly( object.confirmed_at )  
  json.is_confirmed   object.is_confirmed  

end
