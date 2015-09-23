class Api::CustomerStockAdjustmentDetailsController < Api::BaseApiController
  
  def index
    @parent = CustomerStockAdjustment.find_by_id params[:customer_stock_adjustment_id]
    @objects = @parent.active_children.joins(:customer_stock_adjustment, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = CustomerStockAdjustment.find_by_id params[:customer_stock_adjustment_id]
    
  
    @object = CustomerStockAdjustmentDetail.create_object(params[:customer_stock_adjustment_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :customer_stock_adjustment_details => [@object] , 
                        :total => @parent.active_children.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return                          
    end
  end

  def update
    @object = CustomerStockAdjustmentDetail.find_by_id params[:id] 
    @parent = @object.customer_stock_adjustment 
    
    
    params[:customer_stock_adjustment_detail][:customer_stock_adjustment_id] = @parent.id  
    
    @object.update_object( params[:customer_stock_adjustment_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :customer_stock_adjustment_details => [@object],
                        :total => @parent.active_children.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return  
    end
  end

  def destroy
    @object = CustomerStockAdjustmentDetail.find(params[:id])
    @parent = @object.customer_stock_adjustment 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_children.count }  
    else
      render :json => { :success => false, :total =>@parent.active_children.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
      }  
    end
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
      @objects = CustomerStockAdjustmentDetail.joins(:customer_stock_adjustment, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = CustomerStockAdjustmentDetail.joins(:customer_stock_adjustment, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = CustomerStockAdjustmentDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = CustomerStockAdjustmentDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
