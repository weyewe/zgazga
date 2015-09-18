class Api::StockItemsController < Api::BaseApiController
  
  def index
     

    query = Item.joins(:exchange, :item_type, :uom).active_objects
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      
      
      query = query.where{
        ( sku =~ livesearch ) | 
        ( name =~ livesearch ) | 
        ( description  =~ livesearch  ) 
      }  
    end
     
     
     @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count
     
     
     
  end

 
end
