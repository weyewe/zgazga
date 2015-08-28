json.roller_warehouse_mutation_details objects do |object|
    
    json.roller_warehouse_mutation_id 	object.roller_warehouse_mutation_id 
	json.id 	object.id  
	json.recovery_order_detail_id	object.recovery_order_detail_id  
	json.code	object.code  
	json.item_id	object.item_id  
	json.roller_identification_form_detail_id object.recovery_order_detail.roller_identification_form_detail.detail_id 
	if object.recovery_order_detail.roller_identification_form_detail.material_case == 1
        json.item_sku  object.recovery_order_detail.roller_builder.roller_new_core_item.item.sku
        json.item_name  object.recovery_order_detail.roller_builder.roller_new_core_item.item.name
      elsif object.recovery_order_detail.roller_identification_form_detail.material_case == 2
        json.item_sku  object.recovery_order_detail.roller_builder.roller_used_core_item.item.sku
        json.item_name  object.recovery_order_detail.roller_builder.roller_used_core_item.item.name
  end
end