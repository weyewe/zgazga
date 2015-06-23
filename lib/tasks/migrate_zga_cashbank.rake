require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
 


  task :coa => :environment do  

    

    
    migration_filename = MIGRATION_FILENAME[:cash_bank]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1
    
    # create initial hash  from master data
    # get all data which is legacy. create mapping 
    
    # example case: in the old data, id = 5. It is used as parent_id of another account
    # what is the new id?  => it has to migrate coa, exchange rate, and item_type together. 
    # then, create the mapping for further migration
    
=begin

    Create account from cashbank: 
    
    cash_bank_account = Account.find_by_code(ACCOUNT_CODE[:kas_dan_setara_kas][:code])
    new_cash_bank_account = self.new
    new_cash_bank_account.code = cash_bank_account.code + cash_bank.id.to_s
=end

=begin
    Create account from Exchange: 
    
    ar_account = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_2][:code])
    new_ar_account = self.new
    new_ar_account.code = ar_account.code + exchange.id.to_s
=end

    
    
    
    
    
    # based on initial hash, create new data + 
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            parse_code = row[2]
            name = row[3]
            parent_id = row[6]
            
            
            is_legacy = row[7]
            is_leaf = row[8]
            is_cash_bank_account = row[9]
            is_payable_receivable = row[10] 
            
             
            
            is_deleted = false
            is_deleted = true if row[13] == "True" 
            next if is_deleted  
            
            is_legacy = false
            is_legacy = true if row[7] == "True"
            
            is_leaf = false
            is_leaf = true if row[8] == "True" 
            
            is_cash_bank_account = false
            is_cash_bank_account = true if row[9] == "True" 
            
            is_payable_receivable = false
            is_payable_receivable = true if row[10] == "True" 
            
            next if is_legacy | is_cash_bank_account | is_payable_receivable
            
            actual_account_case = ACCOUNT_CASE[:ledger] 
            actual_account_case = ACCOUNT_CASE[:group]  if not is_leaf
              
            
  
            object = Account.create_object( 
                        :name                      => name , 
                        :code                      => code  ,
                        :parent_id                 => new_parent_id , 
                        :account_case              => actual_account_case 
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.name, object.code, object.parent_id, object.account_case  ] 
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
    Account.create_base_objects
    Exchange.create_object_for_base_exchange   # will generate 3 IDR account: GBCH, Payable, and Receivable
    
    
    
    # migrate the cashbank
    
    # build the coa lookup  
 
    
    migration_filename = MIGRATION_FILENAME[:coa]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1
    
    # create initial hash  from master data
    # get all data which is legacy. create mapping 
    
    # example case: in the old data, id = 5. It is used as parent_id of another account
    # what is the new id?  => it has to migrate coa, exchange rate, and item_type together. 
    # then, create the mapping for further migration
    
=begin

    Create account from cashbank: 
    
    cash_bank_account = Account.find_by_code(ACCOUNT_CODE[:kas_dan_setara_kas][:code])
    new_cash_bank_account = self.new
    new_cash_bank_account.code = cash_bank_account.code + cash_bank.id.to_s
=end

=begin
    Create account from Exchange: 
    
    ar_account = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_2][:code])
    new_ar_account = self.new
    new_ar_account.code = ar_account.code + exchange.id.to_s
=end

    
    
    
    
    
    # based on initial hash, create new data + 
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row|
            awesome_row_counter = awesome_row_counter + 1  
            next if awesome_row_counter == 0 
            
            id = row[0]
            code = row[1]
            parse_code = row[2]
            name = row[3]
            parent_id = row[6]
            
            
            is_legacy = row[7]
            is_leaf = row[8]
            is_cash_bank_account = row[9]
            is_payable_receivable = row[10] 
            
             
            
            is_deleted = false
            is_deleted = true if row[13] == "True" 
            next if is_deleted  
            
            is_legacy = false
            is_legacy = true if row[7] == "True"
            
            is_leaf = false
            is_leaf = true if row[8] == "True" 
            
            is_cash_bank_account = false
            is_cash_bank_account = true if row[9] == "True" 
            
            is_payable_receivable = false
            is_payable_receivable = true if row[10] == "True" 
            
            next if is_legacy | is_cash_bank_account | is_payable_receivable
            
            actual_account_case = ACCOUNT_CASE[:ledger] 
            actual_account_case = ACCOUNT_CASE[:group]  if not is_leaf
              
            
  
            object = Account.create_object( 
                        :name                      => name , 
                        :code                      => code  ,
                        :parent_id                 => new_parent_id , 
                        :account_case              => actual_account_case 
                )
                
            object.errors.messages.each {|x| puts "Error: #{x}" } 
                

            result_array << [ id , object.id , object.name, object.code, object.parent_id, object.account_case  ] 
        end
    end
     
 
    # write the new csv LOOKUP file ( with mapping for the ID )
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating account. Total account: #{Account.count}"
  end
  

  
end