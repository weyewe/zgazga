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

  task :migrate_contact_group_and_create_lookup => :environment do  
    
    migration_filename = MIGRATION_FILENAME[:contact_group]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    # Id,Name,Description,IsDeleted,CreatedAt,UpdatedAt,DeletedAt
    
    handler = open( original_location )
    csv_string = handler.read.encode!("UTF-8", "iso-8859-1", invalid: :replace)
    
    CSV.parse(csv_string) do |row| 
      
      
    end
     

    # CSV.open(original_location, 'r') do |csv| 
    #     csv.each do |row|
    #         id = row[0]
    #         name  = row[1]
    #         description = row[2]
    #         object = ContactGroup.create_object( 
    #                 :name => name ,
    #                 :description => description 
    #             )
    #         result_array << [ id , object.id , object.name, object.description ]
    #     end
    # end
     
    # # write the new csv LOOKUP file ( with mapping for the ID )
    # CSV.open(lookup_location, 'w') do |csv|
    #   result_array.each do |el| 
    #     csv <<  el 
    #   end
    # end
  end
  
  task :migrate_contact_and_create_lookup => :environment do
    contact_group_lookup_file = lookup_file_location(  MIGRATION_FILENAME[:contact_group] ) 
    
    migration_filename = MIGRATION_FILENAME[:contact]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
   
    
    #   Id,Name,Address,DeliveryAddress,NPWP,Description,ContactNo,PIC,PICContactNo,Email,IsTaxable,TaxCode,IsDeleted,CreatedAt,UpdatedAt,DeletedAt,ContactType,DefaultPaymentTerm,NamaFakturPajak,ContactGroupId
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            id = row[0]
            name  = row[1]
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
            
            object = ContactGroup.create_object( 
                    :name => name ,
                    :description => description 
                )
            result_array << [ id , object.id , object.name, object.description ]
        end
    end
    
    # for ContactType, the value is null, CUSTOMER, or Supplier
  end
end