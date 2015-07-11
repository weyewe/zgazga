require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'

 
task :generate_json_view do 
    base_path = Rails.root.to_s + "/" + "app/views/" 
    view_api_folder =  base_path + "api/*"
    
    filename_array = [
        "_objects.json.jbuilder",
        "show.json.jbuilder",
        "update.json.jbuilder"
    ]
    
    Dir[ view_api_folder ].each do |folder_location|
        
        
        filename_array.each do | filename |
            full_filename_location = "#{folder_location}/#{filename}"
            
            if File.exist?(full_filename_location)
                puts "#{full_filename_location} exists"
            else
                
                base_json_template_folder = "#{Rails.root.to_s}/lib/tasks/json_view"
                
                puts "gonna generate : #{full_filename_location}"
                form_template = "#{base_json_template_folder}/#{filename}" 
                text = File.open(  form_template ).read 
            
               
            
                result_filename =  full_filename_location
                File.open(result_filename, 'w') { |file| file.write( text ) }  
                 
            end
        end
        
    end
end