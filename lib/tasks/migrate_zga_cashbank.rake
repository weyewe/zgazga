require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 
  
  task :base_setup => :environment do
    Account.create_base_objects
    Exchange.create_object_for_base_exchange   # will generate 3 IDR account: GBCH, Payable, and Receivable
    ItemType.create_base_objects
    # Penjualan
    Menu.create_object(:name => "SalesQuotation",:controller_name => "sales_quotations")
    Menu.create_object(:name => "SalesOrder",:controller_name => "sales_orders")
    Menu.create_object(:name => "DeliveryOrder",:controller_name => "delivery_orders")
    Menu.create_object(:name => "TemporaryDeliveryOrder",:controller_name => "temporary_delivery_orders")
    Menu.create_object(:name => "VirtualOrder",:controller_name => "virtual_orders")
    Menu.create_object(:name => "VirtualDeliveryOrder",:controller_name => "virtual_delivery_orders")
    Menu.create_object(:name => "VirtualOrderClearance",:controller_name => "virtual_order_clearances")
    Menu.create_object(:name => "SalesInvoice",:controller_name => "sales_invoices")
    
    
    # Pembelian
    Menu.create_object(:name => "PurchaseRequest",:controller_name => "purchase_requests")
    Menu.create_object(:name => "PurchaseOrder",:controller_name => "purchase_orders")
    Menu.create_object(:name => "PurchaseReceival",:controller_name => "purchase_receivals")
    Menu.create_object(:name => "PurchaseInvoice",:controller_name => "purchase_invoices")
    
    
    # Logistic
    Menu.create_object(:name => "StockAdjustment",:controller_name => "stock_adjustments")
    Menu.create_object(:name => "CustomerStockAdjustment",:controller_name => "customer_stock_adjustments")
    Menu.create_object(:name => "WarehouseMutation",:controller_name => "warehouse_mutations")
    Menu.create_object(:name => "WarehouseStock",:controller_name => "warehouse_stocks")
    Menu.create_object(:name => "StockItem",:controller_name => "stock_items")
    
    # Batch
    Menu.create_object(:name => "BatchInstance",:controller_name => "batch_instances")
    Menu.create_object(:name => "BatchSource",:controller_name => "batch_sources")
    
    # Finance
    Menu.create_object(:name => "Payable",:controller_name => "payables")
    Menu.create_object(:name => "Receivable",:controller_name => "receivables")
    Menu.create_object(:name => "PaymentRequest",:controller_name => "payment_requests")
    Menu.create_object(:name => "PaymentVoucher",:controller_name => "payment_vouchers")
    Menu.create_object(:name => "ReceiptVoucher",:controller_name => "receipt_vouchers")
    Menu.create_object(:name => "SalesDownPayment",:controller_name => "sales_down_payments")
    Menu.create_object(:name => "SalesDownPaymentAllocation",:controller_name => "sales_down_payment_allocations")
    Menu.create_object(:name => "PurchaseDownPaymentAllocation",:controller_name => "purchase_down_payment_allocations")
    
    
    # Cash dan Bank
    Menu.create_object(:name => "CashBankAdjustment",:controller_name => "cash_bank_adjustments")
    Menu.create_object(:name => "CashBankMutation",:controller_name => "cash_bank_mutations")
    
    # Accounting
    Menu.create_object(:name => "Memorial",:controller_name => "memorials")
    Menu.create_object(:name => "BankAdministration",:controller_name => "bank_administrations")
    Menu.create_object(:name => "TransactionData",:controller_name => "transaction_data")
    Menu.create_object(:name => "Closing",:controller_name => "closings")
    
    # Roller
    Menu.create_object(:name => "RollerIdentificationForm",:controller_name => "roller_identification_forms")
    Menu.create_object(:name => "RecoveryOrder",:controller_name => "recovery_orders")
    Menu.create_object(:name => "RecoveryResult",:controller_name => "recovery_results")
    Menu.create_object(:name => "RollerWarehouseMutation",:controller_name => "roller_warehouse_mutations")
    
    # BlanketConvertion
    Menu.create_object(:name => "BlanketOrder",:controller_name => "blanket_orders")
    Menu.create_object(:name => "BlanketResult",:controller_name => "blanket_results")
    Menu.create_object(:name => "BlanketWarehouseMutation",:controller_name => "blanket_warehouse_mutations")
    
    # Blending
    Menu.create_object(:name => "BlendingWorkOrder",:controller_name => "blending_work_orders")
    Menu.create_object(:name => "UnitConversionOrder",:controller_name => "unit_conversion_orders")
    
    
    # SystemSetup
    Menu.create_object(:name => "User",:controller_name => "users")
    Menu.create_object(:name => "Menu",:controller_name => "menus")
    Menu.create_object(:name => "Employee",:controller_name => "employees")
    
    # Contact
    Menu.create_object(:name => "ContactGroup",:controller_name => "contact_groups")
    Menu.create_object(:name => "Supplier",:controller_name => "suppliers")
    Menu.create_object(:name => "Customer",:controller_name => "customers")
    
    # Inventory Setup
    Menu.create_object(:name => "Warehouse",:controller_name => "warehouses")
    Menu.create_object(:name => "ItemType",:controller_name => "item_types")
    Menu.create_object(:name => "SubType",:controller_name => "sub_types")
    Menu.create_object(:name => "Uom",:controller_name => "uoms")
    Menu.create_object(:name => "Item",:controller_name => "items")
    Menu.create_object(:name => "RollerType",:controller_name => "roller_types")
    
    # Manufacturing Item    
    Menu.create_object(:name => "Machine",:controller_name => "machines")
    Menu.create_object(:name => "CoreBuilder",:controller_name => "core_builders")
    Menu.create_object(:name => "RollerBuilder",:controller_name => "roller_builders")
    Menu.create_object(:name => "Blanket",:controller_name => "blankets")
    Menu.create_object(:name => "BlendingRecipe",:controller_name => "blending_recipes")
    Menu.create_object(:name => "UnitConversion",:controller_name => "unit_conversions")
    
    # FinanceSetup
    Menu.create_object(:name => "CashBank",:controller_name => "cash_banks")
    Menu.create_object(:name => "Account",:controller_name => "accounts")
    Menu.create_object(:name => "Exchange",:controller_name => "exchanges")
    Menu.create_object(:name => "ExchangeRate",:controller_name => "exchange_rates")
    
    # Section.create_base_section_actions
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
    
    cash_bank_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:cash_bank] ) 
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] ) 
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


    # awesome_row_counter = - 1
    # CSV.open(original_location, 'r') do |csv| 
    #     csv.each do |row|
    #         awesome_row_counter = awesome_row_counter + 1  
    #         next if awesome_row_counter == 0 
            
    #         id = row[0]
    #         code = row[1]
            
    #         name = row[3]
    #         parent_id = row[6]
            
    #         is_deleted = false
    #         is_deleted = true if row[13] == "True" 
            
            
    #         is_cash_bank_account = false
    #         is_cash_bank_account = true if row[9] == "True" 
            

          
    #         next if is_deleted 
    #         next if    not is_cash_bank_account 
            
  
            
    #         new_parent_id = nil 
    #         if not parent_id.nil?
    #           new_parent_id = account_mapper_hash[parent_id]
    #           if new_parent_id.nil?
    #             puts "Shhite, the new parent id is nil... can't do anything else. current_code: #{code}"
    #             puts "is_legacy: #{is_legacy}"
    #           end
    #         end

    #         # new account will always be nil. 
    #         # but remember, we have created cashbank. so, there must be an account created
            
    #         # problem: we only need to find the mapping
            
    #         # information: we have code. we only need to extract the linked cash_bank
    #         # based on the linked cash_bank, we can deduce the new code.
    #         # there we have the mapping from old account to new account
            
    #         # new_code = ACCOUNT_CODE[:kas_dan_setara_kas][:code] + cash_bank.id.to_s
            
    #         # puts "ACCOUNT_CODE: #{ACCOUNT_CODE[:kas_dan_setara_kas][:code]} => The code is #{code}"
            
    #         old_cash_bank_id  = code.gsub(ACCOUNT_CODE[:kas_dan_setara_kas][:code], ''  )
            
    #         # puts "the old cb id: #{old_cash_bank_id}"
            
    #         new_cb_id = cash_bank_mapping_hash[old_cash_bank_id]
    #         # puts ">> The new cb id #{new_cb_id}"
            
    #         if not  new_cb_id.nil?
    #           new_account_code = ACCOUNT_CODE[:kas_dan_setara_kas][:code].to_s +  new_cb_id 
    #           account = Account.find_by_code( new_account_code ) 
              
    #           if account.nil?
    #             puts "Fucker.. the account is nil. code: #{code}"
                
    #           else
    #             account_mapper_hash[id] = account.id 
    #           end
    #         end
            

    #     end
    # end
    
    # puts "after additional cashbank"
    # puts account_mapper_hash
    
    # puts "about to prune the coa based on exchange"
    
    


    # awesome_row_counter = - 1
    # CSV.open(original_location, 'r') do |csv| 
    #     csv.each do |row|
    #         awesome_row_counter = awesome_row_counter + 1  
    #         next if awesome_row_counter == 0 
            
    #         id = row[0]
    #         code = row[1]
            
    #         name = row[3]
    #         parent_id = row[6]
            
    #         is_deleted = false
    #         is_deleted = true if row[13] == "True" 
            
            
    #         is_payable_receivable = false
    #         is_payable_receivable = true if row[10] == "True"
            

          
    #         next if is_deleted 
    #         next if    not is_payable_receivable 
            
            
    #         next if  not  ( code.include?( ACCOUNT_CODE[:piutang_usaha_level_2][:code] ) or 
    #             code.include?( ACCOUNT_CODE[:piutang_gbch][:code]) or 
    #             code.include?( ACCOUNT_CODE[:hutang_usaha_level_2][:code] ) or 
    #             code.include?( ACCOUNT_CODE[:hutang_gbch][:code]) ) 
            
            
            
    #         if code.include?(  ACCOUNT_CODE[:piutang_usaha_level_2][:code] )
    #           old_exchange_id  = code.gsub( ACCOUNT_CODE[:piutang_usaha_level_2][:code], ''  )
              
    #           new_exchange_id = exchange_mapping_hash[old_exchange_id] 
            
    #           if not  new_exchange_id.nil?
    #             new_account_code = ACCOUNT_CODE[:kas_dan_setara_kas][:code].to_s +  new_exchange_id 
    #             account = Account.find_by_code( new_account_code ) 
                
    #             if account.nil?
    #               puts "Fucker.. the account is nil. code: #{code}"
                  
    #             else
    #               account_mapper_hash[id] = account.id 
    #             end
    #           else
    #             puts "fark, there is no new_exchange_id for old_exchange_id: #{old_exchange_id}"
    #           end
              
    #         end
            
            
    #         if code.include?(  ACCOUNT_CODE[:piutang_gbch][:code] )
    #           old_exchange_id  = code.gsub( ACCOUNT_CODE[:piutang_gbch][:code], ''  )

    #           new_exchange_id = exchange_mapping_hash[old_exchange_id] 
            
    #           if not  new_exchange_id.nil?
    #             new_account_code = ACCOUNT_CODE[:piutang_gbch][:code].to_s +  new_exchange_id 
    #             account = Account.find_by_code( new_account_code ) 
                
    #             if account.nil?
    #               puts "Fucker.. the account is nil. code: #{code}"
                  
    #             else
    #               account_mapper_hash[id] = account.id 
    #             end
    #           else
    #             puts "fark, there is no new_exchange_id for old_exchange_id: #{old_exchange_id}"
    #           end              
              
              
    #         end
            
    #         if code.include?( ACCOUNT_CODE[:hutang_usaha_level_2][:code]  )
    #           old_exchange_id  = code.gsub( ACCOUNT_CODE[:hutang_usaha_level_2][:code]  , ''  )
              
              
    #           new_exchange_id = exchange_mapping_hash[old_exchange_id] 
            
    #           if not  new_exchange_id.nil?
    #             new_account_code = ACCOUNT_CODE[:hutang_usaha_level_2][:code].to_s +  new_exchange_id 
    #             account = Account.find_by_code( new_account_code ) 
                
    #             if account.nil?
    #               puts "Fucker.. the account is nil. code: #{code}"
                  
    #             else
    #               account_mapper_hash[id] = account.id 
    #             end
    #           else
    #             puts "fark, there is no new_exchange_id for old_exchange_id: #{old_exchange_id}"
    #           end                    
    #         end
            
    #         if code.include?(  ACCOUNT_CODE[:hutang_gbch][:code] )
    #           old_exchange_id  = code.gsub(  ACCOUNT_CODE[:hutang_gbch][:code], ''  )
            
    #           new_exchange_id = exchange_mapping_hash[old_exchange_id] 
            
    #           if not  new_exchange_id.nil?
    #             new_account_code = ACCOUNT_CODE[:hutang_gbch][:code].to_s +  new_exchange_id 
    #             account = Account.find_by_code( new_account_code ) 
                
    #             if account.nil?
    #               puts "Fucker.. the account is nil. code: #{code}"
                  
    #             else
    #               account_mapper_hash[id] = account.id 
    #             end
    #           else
    #             puts "fark, there is no new_exchange_id for old_exchange_id: #{old_exchange_id}"
    #           end   
    #         end
    #         # puts "the old cb id: #{old_cash_bank_id}"
            

            

    #     end
        
    # end
    
    puts "after exchange_pruning"
    puts account_mapper_hash
    result_array = []
    
    account_mapper_hash.each do |key, value|
      result_array << [key, value ]
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating coa. Total coa: #{Account.count}"
  end


end
