class BatchSource < ActiveRecord::Base
    
    def self.create_object( params ) 
      new_object = self.new 

      new_object.item_id            = params[:item_id       ]
      new_object.status             = params[:status      ]
      new_object.source_class       = params[:source_class    ]   
      new_object.source_id          = params[:source_id ] 
      new_object.generated_date     = params[:generated_date  ]      
      new_object.amount             = params[:amount ]
      
      new_object.save
      
      return new_object
    end
    
    def delete_object 
        self.destroy 
    end
    
  
end
