require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

  
  task :core_builder => :environment do
    
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] ) 
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] ) 
    # puts "the contact group mapping hash"
    # puts "#{contact_group_mapping_hash}"
    
    migration_filename = MIGRATION_FILENAME[:core_builder]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
        
          id = row[0]
          base_sku = row[1]
          sku_used_core = row[2]
          sku_new_core = row[3]
          used_core_item_id = row[4]
          new_core_item_id = row[5]
          uo_m_id = row[6]
          machine_id = row[7]
          core_builder_type_case = row[8]
          name = row[9]
          description = row[10]
          c_d = row[11]
          t_l = row[12]
          is_deleted = row[13]
          
          is_taxable = row[12]
          is_taxable = false 
          is_taxable  = true if row[12] == "True" 
          
          tax_code = row[13]
          
          contact_type = row[14]
          # puts "The contact_type: #contact_type}"
          if not contact_type.nil? and not contact_type.length == 0  and contact_type.downcase == "customer"
            contact_type = CONTACT_TYPE[:customer].to_s
          else
            contact_type = CONTACT_TYPE[:supplier].to_s
          end
          
          
          default_payment_term = row[15]
          
          # puts "The row[16]: #{row[16]}"
          is_deleted = false 
          is_deleted  = true if row[16] == "True" 
          
          next if is_deleted 
          
           
    
          # puts "contact_group_id : #{contact_group_id}"
          new_contact_group_id =  contact_group_mapping_hash[contact_group_id]
          # puts "new_contact_group_id: #{new_contact_group_id}"
          
          if ContactGroup.find_by_id( new_contact_group_id.to_i ).nil?
            puts "fucka.. id #{contact_group_id} has no corresponding new contact group "
          end
          
          
          
          # puts "Before create object >>>>>>>>>> contact_type is :#{contact_type} "
          object = Contact.create_object(
              :name => name ,
              :address => address,
              :contact_no => contact_no,
              :delivery_address => delivery_address,
              :description => description,
              :default_payment_term =>  default_payment_term , 
              :npwp => npwp, 
              :is_taxable => is_taxable,  
              :tax_code => tax_code,
              :nama_faktur_pajak => nama_faktur_pajak,
              :pic => pic,
              :pic_contact_no =>  pic_contact_no,
              :email => email,
              :contact_type => contact_type, 
              :contact_group_id => new_contact_group_id
            
            )
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.name, 
                    object.address,
                    object.contact_no, 
                    object.delivery_address,
                    object.description, 
                    object.default_payment_term,
                    object.npwp,
                    object.is_taxable, 
                    object.tax_code,
                    object.nama_faktur_pajak,
                    object.pic,
                    object.pic_contact_no,
                    object.email,
                    object.contact_type,
                    object.contact_group_id  ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating core builder. Total core builder : #{CoreBuilder.count}"
  end
 
  
end