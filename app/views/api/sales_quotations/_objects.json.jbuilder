json.sales_quotations objects do |object|

	json.id 								object.id 
	json.quotation_date 			 format_date_friendly( object.quotation_date )   
	json.is_confirmed 			 object.is_confirmed
	json.is_approved 			 object.is_approved
	json.is_rejected 			 object.is_rejected
	
	json.contact_name 			object.contact.name 
	json.contact_id 				object.contact.id 
	json.description 				object.description
	json.total_quote_amount 				object.total_quote_amount
	json.total_rrp_amount 				object.total_rrp_amount
	json.cost_saved 				object.cost_saved
	json.percentage_saved 				object.percentage_saved
	
	
	json.confirmed_at 						format_date_friendly( 	object.confirmed_at ) 
	
	json.code 					 object.code
	json.version_no 					 object.version_no
 	json.nomor_surat 					 object.nomor_surat
	
	
end