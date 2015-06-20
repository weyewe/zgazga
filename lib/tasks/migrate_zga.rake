require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'



def original_file_location(  migration_filename) 
  BASE_MIGRATION_ORIGINAL_LOCATION + '/' + migration_filename
end

def lookup_file_location(  migration_filename) 
  BASE_MIGRATION_LOOKUP_LOCATION + '/' + migration_filename
end

namespace :migrate_zga do 

  task :contact_group => :environment do  
    
    migration_filename = MIGRATION_FILENAME[:contact_group]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            id = row[0]
            name  = row[1]
            description = row[2]
            object = ContactGroup.create_object( 
                    :name => name ,
                    :description => description 
                )
                
            result_array << [ id , object.id , object.name, object.description ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
  end
  
  def get_mapping_hash( filename) 
    file_location = lookup_file_location(  filename ) 
    
    hash =  {} 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          hash[ row[0] ]  = row[1] 
        end
    end
    
    return hash 
  end
  
  task :contact => :environment do
    
    contact_group_mapping_hash = get_mapping_hash[  MIGRATION_FILENAME[:contact] ]
    
    migration_filename = MIGRATION_FILENAME[:contact]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
   
    
    #   Id,Name,Address,DeliveryAddress,NPWP,Description,ContactNo,PIC,PICContactNo,Email,IsTaxable,TaxCode,IsDeleted,CreatedAt,UpdatedAt,DeletedAt,ContactType,DefaultPaymentTerm,NamaFakturPajak,ContactGroupId
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          id = row[0]
          name = row[1]
          address = row[2]
          delivery_address = row[3]
          npwp = row[4]
          description = row[5]
          contact_no = row[6]
          pic = row[7]
          pic_contact_no = row[8]
          email = row[9]
          is_taxable = row[10]
          tax_code = row[11]
          is_deleted = row[12]
          created_at = row[13]
          updated_at = row[14]
          deleted_at = row[15]
          contact_type = row[16]
          default_payment_term = row[17]
          nama_faktur_pajak = row[18]
          contact_group_id = row[19]
          
          
          next if is_deleted == "True" or is_deleted == "1"
          
          new_contact_group_id =  contact_group_mapping_hash[contact_group_id]
          
          if ContactGroup.find_by_id( new_contact_group_id).nil?
            puts "fucka.. id #{contact_group_id} has no corresponding new contact group "
          end
          
          
          object = Contact.create_object(
              :name => name ,
              :address => address,
              :contact_no => contact_no,
              :delivery_address => delivery_address,
              :description => description,
              :default_payment_term =>  default_payment_term , 
              :npwp => npwp, 
              :is_taxable => true,  
              :tax_code => tax_code,
              :nama_faktur_pajak => nama_faktur_pajak,
              :pic => pic,
              :pic_contact_no =>  pic_contact_no,
              :email => email,
              :contact_type => CONTACT_TYPE[:supplier],
              :contact_group_id => new_contact_group_ids
            
            )
          
            

            result_array << [ id , object.id , object.name, object.description ]
        end
    end
    
    # for ContactType, the value is null, CUSTOMER, or Supplier
  end
end