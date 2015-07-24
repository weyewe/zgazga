class Api::WarehouseStocksController < Api::BaseApiController
  
  def index
     

    query = Warehouse.active_objects
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      
      
      query = query.where{
        ( code =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  )  
      }  
    end
     
     
     @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count
     
     
     
  end

 
end
