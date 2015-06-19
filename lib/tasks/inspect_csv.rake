require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'
require 'rake'

# call this using 
# rake task_name['yhooooo',4]   => no spaces allowed in the argument 
task :task_name, :display_value  do |t, args|
    puts args.display_value 
#   args.display_times.to_i.times do
#     puts args.display_value
#   end
end
 

#  rake inspect_csv['ContactGroup.csv']
task :inspect_csv,  :filename do   | t, args| 
    
 
    filename = args.filename
    
 
  
  
    
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


# rake see_single_column_data['ContactGroup.csv',1]   << no spaces allowed 
task :see_single_column_data , :filename, :column  do | t, args | 
    column = args.column.to_i
    filename = args.filename
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