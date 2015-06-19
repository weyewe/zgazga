require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


 

task :inspect_csv => :environment do
    
    filename = 'Contact.csv'
    csv_file_location = "#{Rails.root}/zga_migration/original/" + filename
    
    handler = open( csv_file_location )
    csv_string = handler.read.encode!("UTF-8", "iso-8859-1", invalid: :replace) 
    
    CSV.parse(csv_string) do |row| 
    end
    
    row_1 = nil 
    CSV.open(csv_file_location, 'r') do |csv| 
        csv.each do |row|
            row_1  =  row
            
            break 
        end
    end
    
    result_string_array = [] 
    counter = 0 
    row_1.each do |col|
        
        tokenized_column_name = col.split /(?=[A-Z])/
    
        downcase_tokenized_column_name = [] 
        tokenized_column_name.each {|x| downcase_tokenized_column_name << x.downcase }
        
    
        string = ""
        string <<  downcase_tokenized_column_name.join("_") + " = "
        string << "row[#{counter}]"
        counter = counter + 1 
        
        result_string_array << string 
    end
    
    puts result_string_array 
    
end

task :see_all_column_data => :environment do
    column = 0
    filename = 'ContactGroup.csv'
    csv_file_location = "#{Rails.root}/zga_migration/original/" + filename
    
    awesome_row_counter = -1 
    result_array = [] 
    
    handler = open( csv_file_location )
    csv_string = handler.read.encode!("UTF-8", "iso-8859-1", invalid: :replace) 
    
    CSV.parse(csv_string) do |row| 
        awesome_row_counter = awesome_row_counter + 1  
        next if awesome_row_counter == 0  
        result_array << row[column]
        
    end
     
     puts result_array 
     
     
end