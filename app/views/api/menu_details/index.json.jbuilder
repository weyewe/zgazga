
json.success true 
json.total @total
 

json.partial! 'objects',   {:objects => @objects, :user_id => @parent.id }  # objects: @objects  , user_object: @parent