require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

  task :uom => :environment do  
 


    
    migration_filename = MIGRATION_FILENAME[:uom]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
                        
            id = row[0]
            name = row[1] 
 
            
            is_deleted = false
            is_deleted = true if row[3] == "True"
            
            next if is_deleted  
            
  
            object = UoM.create_object( 
                    :name => name  
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.name ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating uom. Total uom: #{UoM.count}"
  end
  
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
            name = row[1]
            description = row[2] 
            
            is_deleted = false
            is_deleted = true if row[3] == "True"
            
            next if is_deleted  
            
  
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
    
    puts "Done migrating contact group. Total contact_group: #{ContactGroup.count}"
  end
  

  
  task :item_type => :environment do
    
    account_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:coa] )  
    
    migration_filename = MIGRATION_FILENAME[:item_type]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
          id = row[0]
          name = row[1]
          description = row[2]
          is_legacy = row[3]
          account_id = row[4]
          is_deleted = row[5]
          
           
          is_deleted = false 
          is_deleted  = true if row[5] == "True" 
          
          next if is_deleted 
          
           
     
          new_account_id =  account_mapping_hash[account_id] 
          
          if new_account_id.nil?
            puts "fark, no data in the mapper. old account id #{account_id}. name : #{name}"
          end
          
          next if new_account_id.nil? 
          
          if Account.find_by_id( new_account_id.to_i ).nil?
            puts "fucka.. id #{new_account_id} has no corresponding new contact group "
          end
          
           
          object = ItemType.create_object(
            :name =>  name   ,
            :description => description  , 
            :account_id =>  new_account_id.to_i , 
            )
            
          object.errors.each {|x| puts "error message: #{x}" }  
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.name,  
                    object.description , 
                    object.account_id   ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating item type. Total ItemType: #{ItemType.count}"
  end
  

  
end