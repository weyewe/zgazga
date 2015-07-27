class MenuAction < ActiveRecord::Base
    belongs_to :menu 
    has_many :menu_action_assignments 
    has_many :users, :through => :action_assignments
    
    def self.create_object( params ) 
        new_object = self.new 
        new_object.menu_id =  params[:menu_id]
        new_object.action_name =  params[:action_name]
        new_object.name =  params[:name]
        
        new_object.save
        
        return new_object 
    end
    
    def delete_object
        self.menu_action_assignments.each do |ae|
            ae.delete_object
        end   
        
        self.destroy 
    end
end
