class BatchInstance < ActiveRecord::Base
    
    validates_presence_of :item_id 
    validates_presence_of :name 
    validates_uniqueness_of :name
    
    has_many :batch_source_allocations 
    has_many :batch_sources, :through => :batch_source_allocations
    belongs_to :item 
    
    

      
    def self.create_object( params ) 
        new_object = self.new
        
        new_object.item_id         = params[:item_id]
        new_object.name            = params[:name]
        new_object.description     = params[:description]    
        
        new_object.save
        
        return new_object 
        
    end
    
    def update_object( params ) 
         
        self.name            = params[:name]
        self.description     = params[:description]    
        self.save 
        
        return self 
    end
    
    
    def update_amount( new_amount )
        self.amount = self.amount + new_amount
        self.save 
    end
    
    def delete_object
        if self.batch_source_allocations.count != 0 
            self.errors.add(:generic_errors, "Sudah ada batch source allocation")
            return self 
        end
        
        self.destroy 
    end
end
