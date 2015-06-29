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
          
          
    
          
          object = CoreBuilder.create_object(
            :base_sku => sku,
            :name => name,
            :description => description,
            :uom_id => new_uom_id,
            :machine_id =>  new_machine_id,
            :core_builder_type_case => core_builder_type_case,
            :cd => cd,
            :tl => tl
            )

            
          
           

            result_array << [ id , 
                    object.id , 
                    object.base_sku  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating core builder. Total core builder : #{CoreBuilder.count}"
  end
  
  task :roller_type => :environment do
    
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
    # puts "the contact group mapping hash"
    # puts "#{contact_group_mapping_hash}"
    
    migration_filename = MIGRATION_FILENAME[:roller_type]
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
          is_deleted = row[3]
 
          
          
          is_deleted = false 
          is_deleted  = true if row[3] == "True" 
          
          next if is_deleted 
          
 
          object = RollerType.create_object(
            :name => name,
            :description => description
            )
          
 
           

            result_array << [ id , 
                    object.id , 
                    object.name  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating core RollerType. Total roller type : #{RollerType.count}"
  end
  
  
  # task :roller_builder => :environment do
    
  #   uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
  #   machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
  #   base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
  #   # puts "the contact group mapping hash"
  #   # puts "#{contact_group_mapping_hash}"
    
  #   migration_filename = MIGRATION_FILENAME[:core_builder]
  #   original_location =   original_file_location( migration_filename )
  #   lookup_location =  lookup_file_location(  migration_filename ) 
  #   result_array = [] 
  #   awesome_row_counter = - 1 
    
  #   CSV.open(original_location, 'r') do |csv| 
  #       csv.each do |row| 
  #         awesome_row_counter = awesome_row_counter + 1  
  #         next if awesome_row_counter == 0 
          
 
  #           :base_sku => @base_sku_1,
  #           :name => @name_1,
  #           :description => @description_1,
  #           :uom_id => @uom_1.id,
  #           :adhesive_id => @adhesive_1.id,
  #           :compound_id => @compound_1.id,
  #           :machine_id => @machine_1.id,
  #           :roller_type_id => @roller_type_1.id,
  #           :core_builder_id => @core_builder_1.id,
  #           :is_grooving => @is_grooving_1,
  #           :is_crowning => @is_crowning_1,
  #           :is_chamfer => @is_chamfer_1,
  #           :crowning_size => @crowning_size_1,
  #           :grooving_width => @grooving_width_1,
  #           :grooving_depth => @grooving_depth_1,
  #           :grooving_position => @grooving_position_1,
  #           :cd => @cd_1,
  #           :rd => @rd_1,
  #           :rl => @rl_1,
  #           :wl => @wl_1,
  #           :tl => @tl_1
        
  #         id = row[0]
  #         machine_id = row[1]
  #         roller_type_id = row[2]
  #         compound_id = row[3]
  #         core_builder_id = row[4]
  #         base_sku = row[5]
  #         sku_roller_used_core = row[6]
  #         sku_roller_new_core = row[7]
  #         roller_used_core_item_id = row[8]
  #         roller_new_core_item_id = row[9]
  #         adhesive_id = row[10]
  #         uo_m_id = row[11]
  #         name = row[12]
  #         description = row[13]
  #         r_d = row[14]
  #         c_d = row[15]
  #         r_l = row[16]
  #         w_l = row[17]
  #         t_l = row[18]
  #         is_crowning = row[19]
  #         crowning_size = row[20]
  #         is_grooving = row[21]
  #         grooving_width = row[22]
  #         grooving_depth = row[23]
  #         grooving_position = row[24]
  #         is_chamfer = row[25]
  #         is_deleted = row[26]
  #         created_at = row[27]
  #         updated_at = row[28]
  #         deleted_at = row[29]
          
 
          
          
  #         is_deleted = false 
  #         is_deleted  = true if row[13] == "True" 
          
  #         next if is_deleted 
          
 

  #         if core_builder_type_case == "None"
  #           core_builder_type_case = CORE_BUILDER_TYPE[:none]
  #         end
          
  #         if core_builder_type_case == "Shaft"
  #           core_builder_type_case = CORE_BUILDER_TYPE[:shaft]
  #         end
          
  #         if core_builder_type_case == "Hollow"
  #           core_builder_type_case = CORE_BUILDER_TYPE[:hollow]
  #         end
          
           
  #         new_uom_id =  uom_mapping_hash[uom_id] 
          
  #         if Uom.find_by_id( new_uom_id.to_i ).nil?
  #           puts "fucka.. id #{new_uom_id} has no corresponding new uom "
  #         end
          
  #         new_machine_id =  machine_mapping_hash[machine_id] 
          
  #         if Machine.find_by_id( new_machine_id.to_i ).nil?
  #           puts "fucka.. id #{new_machine_id} has no corresponding new machine_id "
  #         end
          
          
    
          
  #         object = RollerBuilder.create_object(
  #           :base_sku => @base_sku_1,
  #           :name => @name_1,
  #           :description => @description_1,
  #           :uom_id => @uom_1.id,
  #           :adhesive_id => @adhesive_1.id,
  #           :compound_id => @compound_1.id,
  #           :machine_id => @machine_1.id,
  #           :roller_type_id => @roller_type_1.id,
  #           :core_builder_id => @core_builder_1.id,
  #           :is_grooving => @is_grooving_1,
  #           :is_crowning => @is_crowning_1,
  #           :is_chamfer => @is_chamfer_1,
  #           :crowning_size => @crowning_size_1,
  #           :grooving_width => @grooving_width_1,
  #           :grooving_depth => @grooving_depth_1,
  #           :grooving_position => @grooving_position_1,
  #           :cd => @cd_1,
  #           :rd => @rd_1,
  #           :rl => @rl_1,
  #           :wl => @wl_1,
  #           :tl => @tl_1
  #           )

            
          
           

  #           result_array << [ id , 
  #                   object.id , 
  #                   object.base_sku  ]

  #       end
        
  #   end
    
  #   CSV.open(lookup_location, 'w') do |csv|
  #     result_array.each do |el| 
  #       csv <<  el 
  #     end
  #   end
    
  #   puts "Done migrating core builder. Total core builder : #{CoreBuilder.count}"
  # end
 
  
end