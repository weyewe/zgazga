json.suppliers objects do |object| 
	json.id 								object.id  
 
	 
	json.name	object.name
	json.address	object.address
	json.contact_no object.contact_no
	json.delivery_address	object.delivery_address
	json.description	object.description
	json.default_payment_term	object.default_payment_term
	
	
	json.npwp	object.npwp
	json.is_taxable	object.is_taxable
	json.tax_code	object.tax_code
	json.nama_faktur_pajak	object.nama_faktur_pajak
	
	json.pic object.pic
	json.pic_contact_no object.pic_contact_no
	json.email object.email
	json.contact_type object.contact_type
	json.contact_group_id object.contact_group_id
	
	if not object.contact_group_id.nil? 
		json.contact_group_name object.contact_group.name 
	else 
		json.contact_group_name ""
	end
	
	  


	
end


