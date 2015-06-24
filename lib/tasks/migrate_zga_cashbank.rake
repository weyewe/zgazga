require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
  task :base_setup => :environment do
    Account.create_base_objects
    Exchange.create_object_for_base_exchange   # will generate 3 IDR account: GBCH, Payable, and Receivable
    ItemType.create_base_objects
  end
 
 
  task :exchange => :environment do  

    

    
    migration_filename = MIGRATION_FILENAME[:exchange]
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
                        
                        
            is_base = false
            is_base = true if row[3] == "True" 
            
             
            
            is_deleted = false
            is_deleted = true if row[4] == "True" 
            next if is_deleted  
             
              
            
            object = nil 
            
            if not is_base
              object = Exchange.create_object( 
                        :name           => name , 
                        :description    => description  
                )
                
              object.errors.messages.each {|x| puts "Error: #{x}" } 
            else
              object = Exchange.find_by_name EXCHANGE_BASE_NAME
            end
            
                

            result_array << [ id , object.id , object.name, object.description  ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating exchange. Total exchange: #{Exchange.count}"
  end


  task :cash_bank => :environment do  

    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] ) 
  # puts "exchange_mapping_hash: >>>>>>>>>>>>>>>>>\n\n"
  # puts exchange_mapping_hash
    
    migration_filename = MIGRATION_FILENAME[:cash_bank]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            name = row[2]
            description = row[3]
            exchange_id = row[4] 
            
             
            is_bank = false
            is_bank = true if row[6] == "True" 
            
            is_deleted = false
            is_deleted = true if row[7] == "True" 
            next if is_deleted  
             
              
            new_exchange_id =  exchange_mapping_hash[exchange_id]
  
            object = CashBank.create_object( 
                        :name                   => name , 
                        :description            => description  ,
                        :is_bank                => is_bank , 
                        :exchange_id            => new_exchange_id 
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.name, object.description, object.is_bank, object.exchange_id ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating cashbank. Total cashbank: #{CashBank.count}"
  end
  

  task :coa => :environment do  
    # base migration

    
    # migrate the cashbank
    
    # build the coa lookup  
 
    
    migration_filename = MIGRATION_FILENAME[:coa]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    
    
    
  
    # simplest case: if there is no cashbank or currency 
    
    # only legacy involved 
    
    # only have: boolean column: is_legacy , and code 
    
    # for each row, extract the data to be shown. 
    # if legacy: find the similar column in the database. take note of the id 
    
    account_mapper_hash = {} 
    awesome_row_counter = - 1
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            
            name = row[3]
            parent_id = row[6]
            
            
            is_legacy = false
            is_legacy = true if row[7] == "True"
          
            next if   not is_legacy  
            
            new_account = Account.find_by_code code 
            if new_account.nil?
              puts "emergency in account migration: #{id} - #{code} has no match"
            else
              account_mapper_hash[id] = new_account.id
            end
              
        end
    end
    
    
    puts "the account mapper"
    puts account_mapper_hash    #( purely created account ) 
    
=begin
  Next, we are having something new: non legacy, but not generated from somewhere else
=end
    
      
    awesome_row_counter = - 1
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            
            name = row[3]
            parent_id = row[6]
            
            
            is_cash_bank_account = false
            is_cash_bank_account = true if row[9] == "True" 
            
            is_payable_receivable = false
            is_payable_receivable = true if row[10] == "True" 
            
            is_legacy = false
            is_legacy = true if row[7] == "True"
          
            next if    is_legacy   or  is_cash_bank_account or  is_payable_receivable 
            
            is_leaf = false
            is_leaf = true if row[8] == "True" 
            
            actual_account_case = ACCOUNT_CASE[:ledger] 
            actual_account_case = ACCOUNT_CASE[:group]  if not is_leaf
              
            
            new_parent_id = nil 
            if not parent_id.nil?
              new_parent_id = account_mapper_hash[parent_id]
              if new_parent_id.nil?
                puts "Shhite, the new parent id is nil... can't do anything else. current_code: #{code}"
                puts "is_legacy: #{is_legacy}"
              end
            end

  
  

    
    

            
            
            
            new_account = Account.find_by_code code 
            if new_account.nil?

              object = Account.create_object( 
                          :name                      => name , 
                          :code                      => code  ,
                          :parent_id                 => new_parent_id , 
                          :account_case              => actual_account_case 
                  )
             account_mapper_hash[id] = object.id 
            else
              account_mapper_hash[id] = new_account.id
            end
              
        end
    end
    
    puts "after additional free account"
    puts account_mapper_hash
    
    
    puts "\n >>>>> now we are going to prune it using cashbank"
    
    
    
    
  
  # account table is a self-join table. 
  # migration strategy is to create lookup table 
=begin

    Create account from cashbank: 
    
    cash_bank_account = Account.find_by_code(ACCOUNT_CODE[:kas_dan_setara_kas][:code])
    new_cash_bank_account = self.new
    new_cash_bank_account.code = cash_bank_account.code + cash_bank.id.to_s
=end

=begin
    Create account from Exchange (4 accounts created): 
    
#     create ar
    ar_account = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_2][:code])
    new_ar_account = self.new
    new_ar_account.code = ar_account.code + exchange.id.to_s
    new_ar_account.name = "Account Receivable " + exchange.name.to_s
    
#     create ar_gbch
    ar_gbch_account = Account.find_by_code(ACCOUNT_CODE[:piutang_gbch][:code])
    new_ar_gbch_account = self.new
    new_ar_gbch_account.code = ar_gbch_account.code + exchange.id.to_s
    new_ar_gbch_account.name = "GBCH Receivable" + exchange.name.to_s
    
#     create ap
    ap_account = Account.find_by_code(ACCOUNT_CODE[:hutang_usaha_level_2][:code])
    new_ap_account = self.new
    new_ap_account.code =  ap_account.code + exchange.id.to_s
    new_ap_account.name = "Account Payable" + exchange.name.to_s
    
#     create gbch_payable
    ap_gbch_payable_account = Account.find_by_code(ACCOUNT_CODE[:hutang_gbch][:code])
    new_ap_gbch_payable_account = self.new
    new_ap_gbch_payable_account.code =  ap_gbch_payable_account.code + exchange.id.to_s
    new_ap_gbch_payable_account.name = "Account Payable" + exchange.name.to_s    
    
    
    
=end


  
    
     
    
    # based on initial hash, create new data + 
    # CSV.open(original_location, 'r') do |csv| 
    #     csv.each do |row|
    #         awesome_row_counter = awesome_row_counter + 1  
    #         next if awesome_row_counter == 0 
            
    #         id = row[0]
    #         code = row[1]
            
    #         name = row[3]
    #         parent_id = row[6]
            
            
    #         is_legacy = row[7]
    #         is_leaf = row[8]
    #         is_cash_bank_account = row[9]
    #         is_payable_receivable = row[10] 
            
             
            
    #         is_deleted = false
    #         is_deleted = true if row[13] == "True" 
    #         next if is_deleted  
            
    #         is_legacy = false
    #         is_legacy = true if row[7] == "True"
            
    #         is_leaf = false
    #         is_leaf = true if row[8] == "True" 
            
    #         is_cash_bank_account = false
    #         is_cash_bank_account = true if row[9] == "True" 
            
    #         is_payable_receivable = false
    #         is_payable_receivable = true if row[10] == "True" 
            
    #         next if is_legacy | is_cash_bank_account | is_payable_receivable
            
    #         actual_account_case = ACCOUNT_CASE[:ledger] 
    #         actual_account_case = ACCOUNT_CASE[:group]  if not is_leaf
              
            
  
            # object = Account.create_object( 
            #             :name                      => name , 
            #             :code                      => code  ,
            #             :parent_id                 => new_parent_id , 
            #             :account_case              => actual_account_case 
            #     )
                
    #         object.errors.messages.each {|x| puts "Error: #{x}" } 
                

    #         result_array << [ id , object.id , object.name, object.code, object.parent_id, object.account_case  ] 
    #     end
    # end
     
 
    # # write the new csv LOOKUP file ( with mapping for the ID )
    # CSV.open(lookup_location, 'w') do |csv|
    #   result_array.each do |el| 
    #     csv <<  el 
    #   end
    # end
    
    # puts "Done migrating account. Total account: #{Account.count}"
  end
  

  
end