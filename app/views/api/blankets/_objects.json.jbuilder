
json.blankets objects do |object|
	json.id     object.id  
	json.sku    object.sku
	json.name    object.name
	json.uom_id    object.uom_id
	json.uom_name 	object.uom.name
	json.amount    object.amount
	json.description    object.description
	json.contact_id     object.contact_id  
	json.contact_name     object.contact.name
	json.machine_id   object.machine_id  
	json.machine_name     object.machine.name  
	json.adhesive_id    object.adhesive_id  
	if not (object.adhesive_id.nil? ||  object.adhesive_id == 0)
		json.adhesive_name object.adhesive.name 
	else 
		json.adhesive_name ""
	end
	json.adhesive2_id     object.adhesive2_id  
	if not (object.adhesive2_id.nil? ||  object.adhesive_id == 0)
		json.adhesive2_name object.adhesive2.name 
	else 
		json.adhesive2_name ""
	end
	json.roll_blanket_item_id     object.roll_blanket_item_id  
	json.roll_blanket_item_name     object.roll_blanket_item.name
	json.left_bar_item_id     object.left_bar_item_id  
	json.right_bar_item_id     object.right_bar_item_id 
	if not (object.left_bar_item_id.nil? ||  object.left_bar_item_id == 0)
		json.left_bar_item_name object.left_bar_item.name 
	else 
		json.left_bar_item_name ""
	end
	if not (object.right_bar_item_id.nil? ||  object.right_bar_item_id == 0)
		json.right_bar_item_name object.right_bar_item.name 
	else 
		json.right_bar_item_name ""
	end
	json.ac     object.ac  
	json.ar     object.ar  
	json.thickness    object.thickness  
	json.ks     object.ks  
	json.is_bar_required    object.is_bar_required  
	json.has_left_bar     object.has_left_bar  
	json.has_right_bar    object.has_right_bar  
	json.cropping_type    object.cropping_type  
	if object.cropping_type = CROPPING_TYPE[:normal]
		json.cropping_type_text "Normal"
	elsif object.cropping_type_text = CROPPING_TYPE[:special]
		json.cropping_type_text "Special"
	elsif object.cropping_type_text = CROPPING_TYPE[:none]
		json.cropping_type_text "None"
	end
	json.left_over_ac     object.left_over_ac  
	json.special    object.special  
	json.application_case     object.application_case  
	if object.application_case == APPLICATION_CASE[:sheetfed]
		json.application_case_text "Sheetfed" 
	elsif object.application_case == APPLICATION_CASE[:web]
		json.application_case_text "Web" 
	elsif object.application_case == APPLICATION_CASE[:both]
		json.application_case_text "Both" 
	elsif object.application_case == APPLICATION_CASE[:none]
		json.application_case_text "None" 
	end
end


