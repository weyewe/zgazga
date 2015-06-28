require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

  
  task :core_builder => :environment do
    
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
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
          sku = row[1] 
          uom_id = row[6]
          machine_id = row[7]
          core_builder_type_case = row[8]
          name = row[9]
          description = row[10]
          cd = row[11]
          tl = row[12]
          
 
          
          
          is_deleted = false 
          is_deleted  = true if row[13] == "True" 
          
          next if is_deleted 
          
 

          if core_builder_type_case == "None"
            core_builder_type_case = CORE_BUILDER_TYPE[:none]
          end
          
          if core_builder_type_case == "Shaft"
            core_builder_type_case = CORE_BUILDER_TYPE[:shaft]
          end
          
          if core_builder_type_case == "Hollow"
            core_builder_type_case = CORE_BUILDER_TYPE[:hollow]
          end
          
           
          new_uom_id =  uom_mapping_hash[uom_id] 
          
          if Uom.find_by_id( new_uom_id.to_i ).nil?
            puts "fucka.. id #{new_uom_id} has no corresponding new uom "
          end
          
          new_machine_id =  machine_mapping_hash[machine_id] 
          
          if Machine.find_by_id( new_machine_id.to_i ).nil?
            puts "fucka.. id #{new_machine_id} has no corresponding new machine_id "
          end
          
          
          
          minimum_amount = '0'
          selling_price  = '0'
          price_list = '0'
          # puts "Before create object >>>>>>>>>> contact_type is :#{contact_type} "
          object = CoreBuilder.create_object(
              :sku =>  sku , 
              :name =>  name  ,
              :description =>  description,  
              :uom_id =>  new_uom_id , 
              :minimum_amount =>  BigDecimal( minimum_amount  || '0')  , 
              :selling_price =>  BigDecimal( selling_price || '0')  ,
              :exchange_id => base_exchange.id , 
              :price_list =>  BigDecimal( price_list || '0')  , 
              :core_builder_type_case =>  core_builder_type_case , 
              :machine_id => new_machine_id , 
              :cd => BigDecimal( cd || '0') , 
              :tl =>  BigDecimal(  tl  || '0') 
            
            )
            
          
           

            result_array << [ id , 
                    object.id , 
                    object.sku  ]

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