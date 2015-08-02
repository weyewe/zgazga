class MenuActionAssignment < ActiveRecord::Base
    belongs_to :user
    belongs_to :menu_action 
    
    validates_presence_of :user_id, :menu_action_id
    
    validate :unique_assignment
    
    def unique_assignment
        return if not user_id.present? or not menu_action_id.present? 
        
        object = User.find_by_id user_id
        if object.nil?
            self.errors.add(:generic_errors, "Harus ada user")
            return self 
        end
        
        object = MenuAction.find_by_id  menu_action_id
        if object.nil?
            self.errors.add(:generic_errors, "Harus ada menu action")
            return self 
        end
        
        if MenuActionAssignment.where(:menu_action_id => menu_action_id, :user_id => user_id ).count != 0 
            self.errors.add(:generic_errors, "Tidak boleh duplikat")
            return self 
        end
    end
    
    def self.create_object( params ) 
        new_object = self.new 
        new_object.user_id = params[:user_id]
        new_object.menu_action_id = params[:menu_action_id]
        
        new_object.save
        
        return new_object
    end
    
    def delete_object
        self.destroy 
    end
    
end
