
json.menu_details objects do |object|

 
	json.id 								object.id  
	json.name           object.name 
	json.user_id  user_id
	
    
    json.index      object.is_action_allowed?( "index", user_id )  # object.is_view_allowed?( user_object ) 
    json.create  object.is_action_allowed?( "create", user_id )  # object.is_view_allowed?( user_object ) 
    json.update  object.is_action_allowed?( "update", user_id )  # object.is_view_allowed?( user_object ) 
    json.confirm  object.is_action_allowed?( "confirm", user_id )  # object.is_view_allowed?( user_object ) 
    
    json.unconfirm  object.is_action_allowed?( "unconfirm", user_id )  # object.is_view_allowed?( user_object ) 
    json.destroy   object.is_action_allowed?( "destroy", user_id )    # object.is_view_allowed?( user_object ) 
    
    
 
	
end
