class Api::StockItemDetailsController < Api::BaseApiController
  
  
  def parent_controller_name
      "stock_items"
  end
  
   def index
    @parent = Item.find_by_id params[:stock_item_id]
    
    query  = WarehouseItem.joins( :warehouse, :item => [:uom]).where(
        :item_id => @parent.id 
      ) 
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( warehouse.name =~  livesearch ) | 
           ( warehouse.code =~ livesearch)   
         )         
       } 
     end
    
    @objects =  query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end
 
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      
      query_code = WarehouseItem.joins( :warehouse, :item => [:uom]).where{
                ( item.name =~  query ) | 
                ( item.sku =~ query)   
                }
                              
      if params[:item_id].present?
        object = Item.find_by_id params[:item_id]
        if not object.nil?  
          query_code = query_code.where(:item_id => object.id )
        end
      end    
      
      @objects = query_code.page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
      @total = query_code.count 
    else
      query_code =  WarehouseItem.joins( :warehouse, :item => [:uom]).where{ 
              (item_id.eq selected_id)  
      }
      @objects = query_code.
                  page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
   
      @total = query_code.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
  
 
end
