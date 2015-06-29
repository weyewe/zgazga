require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

  
  task :independent_item => :environment do
    
    core_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:core]
    roller_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:roller]
    blanket_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:blanket]
    
    # puts "core_item_type: #{core_item_type.id}"
    # puts "roller_item_type: #{roller_item_type.id}"
    # puts "blanket_item_type: #{blanket_item_type.id}"
    
    item_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item_type] ) 
    sub_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sub_type] )  
    uom_mapping_hash  = get_mapping_hash( MIGRATION_FILENAME[:uom])
    exchange_mapping_hash = get_mapping_hash( MIGRATION_FILENAME[:exchange]) 
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
    
 
    
    migration_filename = MIGRATION_FILENAME[:item]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
           

          id = row[0]
          item_type_id = row[1]
          sub_type_id = row[2]
          sku = row[3]
          name = row[4]
          description = row[5]
          is_tradeable = row[6]
          uom_id = row[7]
          minimum_quantity = row[12]
          selling_price = row[15]
          price_list = row[16]
          exchange_id = row[17]
          is_deleted = row[21] 
 
 
          new_item_type_id =  item_type_mapping_hash[item_type_id] 
          new_sub_type_id = sub_type_mapping_hash[sub_type_id]
          new_uom_id = uom_mapping_hash[uom_id]
          new_exchange_id = exchange_mapping_hash[exchange_id]
          
          
          if selling_price.to_i == 0
            selling_price = "100"
          end
          
          if minimum_quantity.to_i == 0
            minimum_quantity = "100"
          end
          
          if price_list.to_i == 0
            price_list = "100"
          end
          
          
          
          if new_exchange_id.nil?
            new_exchange_id = base_exchange.id 
          end
          
          next if new_item_type_id.to_i == core_item_type.id or 
                  new_item_type_id.to_i == roller_item_type.id or 
                  new_item_type_id.to_i == blanket_item_type.id
            
          is_deleted = false 
          is_deleted  = true if row[21] == "True" 
          
          next if is_deleted 
          
          is_tradeable = false 
          is_tradeable  = true if row[6] == "True" 
          
 
          object = Item.create_object(
              :item_type_id => new_item_type_id ,
              :sub_type_id => new_sub_type_id,
              :sku => sku,
              :name => name,
              :description => description,
              :is_tradeable => is_tradeable,
              :uom_id => new_uom_id,
              :minimum_amount => minimum_quantity,
              :selling_price => selling_price,
              :exchange_id => new_exchange_id,
              :price_list => price_list
            )
          
          object.errors.messages.each do |x|
            puts "error: #{x}. Old id: #{id}. #{row[21]}" 
            puts "item_type_id : #{item_type_id}"
            puts "new_item_type_id : #{new_item_type_id}"
          end
            
 
           

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
    
    puts "Done migrating  independent Item. Total independent item : #{Item.count}"
  end
  
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