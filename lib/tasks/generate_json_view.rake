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

task :move_index_to_objects_partial do 
    puts "gonna move it"
    base_path = Rails.root.to_s + "/" + "app/views/" 
    view_api_folder =  base_path + "api/*"
    
 
    Dir[ view_api_folder ].each do |folder_location|
        
        
        


         
        index_filename_location = "#{folder_location}/index.json.jbuilder"
        objects_filename_location = "#{folder_location}/_objects.json.jbuilder"
        
        if File.exist?(index_filename_location) and File.exist?(objects_filename_location)
            base_result = ""
            partial_block_result = "" 
            final_result  = "" 
            
            start_copy = false 
            File.open(index_filename_location).each do |line|
               base_result << line
               
               start_copy = true if line.include?("@objects") and line.include?("do")
               
               if start_copy
                   partial_block_result << line 
               end
               
               
            end
            
            final_result = base_result.gsub( partial_block_result, '')
            final_result << "json.partial! 'objects', objects:  @objects"
            
            if partial_block_result.length != 0
                
                
                puts "gonna replace the index: #{index_filename_location}"
                target_content = partial_block_result.gsub("@objects", "objects")
                File.open(objects_filename_location, 'w') { |file| file.write( target_content ) }
                File.open(index_filename_location, 'w') { |file| file.write( final_result ) }
                # puts target_content
                # break
            end
            # puts final_result
             
        end  
    end
end