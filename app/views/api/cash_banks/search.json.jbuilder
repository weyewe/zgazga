
json.success true 
json.total @total
 

json.records @objects do |object|
    
    
  	json.id 								object.id  			
  json.name							object.name
  json.description 						object.description 
	json.amount						object.amount
	json.is_bank					object.is_bank
	json.code							object.code
	json.payment_code							object.payment_code
	json.exchange_id object.exchange_id
	json.exchange_name object.exchange.name 
	
	
end
