json.success true 
json.total @total


# json.partial! 'objects', objects:  @objects
if @parent.present?
    json.partial! 'objects',   {:objects => @objects, :parent_id => @parent.id, :parent_name => @parent.name  } 
else
    json.partial! 'objects',   {:objects => @objects, :parent_id => nil , :parent_name => nil } 
end
