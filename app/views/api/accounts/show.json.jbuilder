json.success true 
json.total @total
 
#json.partial! 'objects', objects: [ @object]

json.partial! 'objects',   {:objects => @objects, :parent_id => @parent.id, :parent_name => @parent.name  } 
 