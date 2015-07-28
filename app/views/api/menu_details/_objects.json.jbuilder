
json.menu_details objects do |object|

 
	json.id 								object.id  
	json.name           object.name 
	
    
    json.is_view_allowed     false # object.is_view_allowed?( user_object ) 
    json.is_create_allowed  false # object.is_view_allowed?( user_object ) 
    json.is_update_allowed  false # object.is_view_allowed?( user_object ) 
    json.is_confirm_allowed  false # object.is_view_allowed?( user_object ) 
    
    json.is_unconfirm_allowed  false # object.is_view_allowed?( user_object ) 
    json.is_delete_allowed   false # object.is_view_allowed?( user_object ) 
    
    
 
	
end
