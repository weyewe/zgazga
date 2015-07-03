
json.success true 
json.total @total
json.roller_types @objects do |object|
	json.id 								object.id  
  json.name		object.name  
  json.description 		object.description
end


