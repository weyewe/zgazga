
json.success true 
json.total @total
  
json.blanket_result_details @objects do |object|
    
	json.id 								object.id  
	json.batch_source_id                object.batch_source_id 
	
	json.batch_instance_id              object.batch_instance_id 
	json.batch_instance_name                 object.batch_instance.name 
	json.amount                 object.amount 
	 
end
