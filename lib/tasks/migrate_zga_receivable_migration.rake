require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

 
  task :outstanding_sales_invoice => :environment do
    
    
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] )  
    contact_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:outstanding_sales_invoice]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
          id = row[0]
          nomor_surat = row[1]
          contact_id = row[2]
          exchange_id = row[3]
          exchange_rate_amount = row[4]
          amount_receivable = row[5]
          tax = row[6]
          dpp = row[7]
          invoice_date = row[8]
          is_deleted = false
          is_deleted = true if row[11] == "True"
          
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          
          
          new_exchange_id = exchange_mapping_hash[exchange_id]
          new_contact_id = contact_mapping_hash[contact_id]
          parsed_invoice_date = get_parsed_date(invoice_date)
          
          
          object = SalesInvoiceMigration.create_object(
            :nomor_surat =>  nomor_surat,
            :contact_id =>  new_contact_id,
            :exchange_id => new_exchange_id,
            :amount_receivable =>  amount_receivable,
            :exchange_rate_amount => exchange_rate_amount,
            :tax => tax,
            :dpp =>  dpp,
            :invoice_date =>  parsed_invoice_date
            )
             
            
            
          object.errors.messages.each {|x| puts "Error: #{x}" } 
          
           

          result_array << [ id , 
                    object.id  
                    ]
        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating SalesInvoiceMigration. Total SalesInvoiceMigration: #{SalesInvoiceMigration.count}"
  end
  
  task :receivable => :environment do
    
    
    sales_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sales_invoice] )  
    outstanding_sales_invoice_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:outstanding_sales_invoice] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:receivable]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    lookup_counter = 0 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
                    
          id = row[0]
          contact_id = row[1]
          receivable_source = row[2]
          receivable_source_id = row[3]
          code = row[4]
          currency_id = row[5]
          rate = row[6]
          due_date = row[7]
          amount = row[8]
          remaining_amount = row[9]
          pending_clearance_amount = row[10]
          is_completed = row[11]
          completion_date = row[12]
          is_deleted = row[13]
          created_at = row[14]
          updated_at = row[15]
          deleted_at = row[16]
          
          
          
       
       
       
          
          
          is_deleted = get_truth_value(is_deleted ) 
          next if is_deleted
          
          object = nil 
          
          
          if receivable_source == "SalesInvoice"
            new_sales_invoice_id = sales_invoice_mapping_hash[receivable_source_id]
            
            if new_sales_invoice_id.nil? 
              puts "fuck. new_sales_invoice_id is nil.. receivable_id : #{id}"
              next
            end
            
 
    
            object   = Receivable.where(
                :source_class => "SalesInvoice",
                :source_id => new_sales_invoice_id
              ).first 
              
              

            
          elsif receivable_source == "SalesInvoiceMigration"
            new_sales_invoice_migration_id = outstanding_sales_invoice_mapping_hash[receivable_source_id]
            
            if new_sales_invoice_migration_id.nil? 
              puts "fuck. new_sales_invoice_migration_id is nil.. receivable_id : #{id}"
              next
            end
            
            object   = Receivable.where(
                :source_class => "SalesInvoiceMigration",
                :source_id => new_sales_invoice_migration_id
              ).first 
              
            
          else
            puts "Fark, another source receivable. id: #{id}"
            next
          end
          
          
 

          if not object.nil? 
            lookup_counter = lookup_counter + 1 
            result_array << [ id ,    object.id    ] 
          end
          

        end
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating Receivable. Total Receivable: #{ lookup_counter}"
  end
  
  

  task :outstanding_piutang => :environment do
    
    
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] )  
    contact_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact] ) 
    
  
    
    migration_filename = MIGRATION_FILENAME[:outstanding_piutang]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
                    
          contact_id = row[0]
          contact_name = row[1]
          invoice_date = row[2]
          tukar_faktur_date = row[3]
          no_faktur = row[4]
          usd_amount = row[5]
          euro_amount = row[6]
          idr_amount = row[7]
          
          
          
          # not present if "" or '-' or nothing
          
          if tukar_faktur_date.present?
            tukar_faktur_date = tukar_faktur_date.strip  
          end
          
          if usd_amount.present?
            usd_amount = usd_amount.strip 
          end
          
          if euro_amount.present?
            euro_amount = euro_amount.strip  
          end
          
          if idr_amount.present?
            idr_amount = idr_amount.strip 
          end
          
          
          msg = "#{awesome_row_counter} : tukar_faktur_date #{tukar_faktur_date}  | "
          msg << "usd_amount #{usd_amount}  | "
          msg << "euro_amount #{euro_amount} | "
          msg << "idr_amount #{idr_amount}"
          
          # puts msg 
           
          
          tukar_faktur_date = nil if tukar_faktur_date == '-' or  not tukar_faktur_date.present? 
          usd_amount = usd_amount.gsub('-', '') if not usd_amount.nil?
          euro_amount = euro_amount.gsub('-', '') if not euro_amount.nil?
          idr_amount = idr_amount.gsub('-', '')   if not idr_amount.nil?
          

          
# USD 
# EURO 
# RUPIAH 
 
          # msg = "old contact => #{contact_id}, #{contact_name}  | " 
          
          if contact_mapping_hash[contact_id].nil?
            msg << "FARK.. no mapping"
            
            puts msg
          else
            new_contact = Contact.find_by_id contact_mapping_hash[contact_id]
            msg << "new_contact_name : #{new_contact.name}"
          end
          
          
          new_contact_id  = contact_mapping_hash[contact_id]
          
                      
                      
                      
#           [[1, "Rupiah"], [2, "USD"], [3, "Euro"], [4, "CHF"], [5, "GBP"], [6, "SGD"]] 
 
          new_exchange_id = 2 if usd_amount.present? 
          new_exchange_id = 3 if euro_amount.present? 
          new_exchange_id = 1 if not usd_amount.present? and not euro_amount.present? 
          msg << "usd_amount #{usd_amount}"
          msg << "euro_amount #{euro_amount}"
          # puts ">>> the currency inspect"
          msg << "exchange_id #{new_exchange_id}"
          # puts msg
          
          invoice_date = Date.parse( invoice_date )
          parsed_invoice_date = get_parsed_date(invoice_date.to_s )
          
          if  tukar_faktur_date.present? 
    
            tukar_faktur_date = Date.parse( tukar_faktur_date ) 
            
          end
 
          if new_exchange_id.nil?
            puts exchange_hash
            puts "nomor surat: #{nomor_surat}, exchange_name: #{exchange_name}"
            
          end
          
          amount_foreign_exchange  = BigDecimal("0") if not usd_amount.present? and not euro_amount.present?
          amount_foreign_exchange = usd_amount if usd_amount.present?
          amount_foreign_exchange = euro_amount if euro_amount.present? 
          
          
          if not idr_amount.present? 
            amount_base_exchange = BigDecimal("0") 
          else
            amount_base_exchange = BigDecimal( idr_amount )
          end
          
          
          if amount_base_exchange == BigDecimal("0") 
            puts "This shite with no surat: #{no_faktur} is dangerous"
            next
          end
          
          # puts "The exchange_id: #{new_exchange_id}"
          
          object = ReceivableMigration.create_object(
                    :nomor_surat => no_faktur, 
                    :contact_id  => new_contact_id,
                    :exchange_id => new_exchange_id,
                    :amount_base_exchange => amount_base_exchange ,
                    :amount_foreign_exchange => amount_foreign_exchange,
                    :invoice_date => invoice_date , 
                    :tukar_faktur_date  => tukar_faktur_date
              )
            
          object.errors.messages.each {|x| puts "Error: #{x}" } 
    
        end
    end
    
 
    
    puts "Done migrating Piutang. Total ReceivableMigration: #{ReceivableMigration.count}"
  end
  
end