=begin

Menu.create_object(
    :name => "Sales Order",
    :controller_name => "sales_orders"
)
=end



class Menu < ActiveRecord::Base
    has_many :menu_actions 
    
    
    def self.active_objects
        self
    end
    
    
    def self.create_object(params) 
        new_object = self.new 
        
        new_object.name = params[:name]
        new_object.controller_name = params[:controller_name]
        
        if new_object.save
            target_result = [
                ["View", "index"],
                ["Create", "create"],
                ["Update", "update"],
                ["Confirm", "confirm"],
                ["Unconfirm", "unconfirm"],
                ["Delete", "destroy"],
            ]
            
            target_result.each do |row|
                MenuAction.create_object(
                        :menu_id => new_object.id, 
                        :name => row[0],
                        :action_name => row[1]
                    )
            end
        end
    end
    
    def delete_object
        self.menu_actions.each do |menu_action|
            menu_action.delete_object
            
        end
        
        self.destroy 
    end
    
    
end
