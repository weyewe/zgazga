class Api::TemporaryDeliveryOrderDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "temporary_delivery_orders"
  end
  
  def index
    @parent = TemporaryDeliveryOrder.find_by_id params[:temporary_delivery_order_id]
    query = @parent.active_children.joins(:temporary_delivery_order, :item , :sales_order_detail)
    
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( item.name =~  livesearch ) | 
           ( code =~  livesearch ) | 
           ( item.sku =~ livesearch)   
         )         
       } 
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = TemporaryDeliveryOrder.find_by_id params[:temporary_delivery_order_id]
    
  
    @object = TemporaryDeliveryOrderDetail.create_object(params[:temporary_delivery_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :temporary_delivery_order_details => [@object] , 
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
    @object = TemporaryDeliveryOrderDetail.find_by_id params[:id] 
    @parent = @object.temporary_delivery_order 
    
    
    params[:temporary_delivery_order_detail][:temporary_delivery_order_id] = @parent.id  
    
    @object.update_object( params[:temporary_delivery_order_detail])
     
    if @object.errors.size == 0 
      @total = @parent.active_children.count
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
    @object = TemporaryDeliveryOrderDetail.find(params[:id])
    @parent = @object.temporary_delivery_order 
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
      @objects = TemporaryDeliveryOrderDetail.joins(:temporary_delivery_order, :item , :sales_order_detail).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = TemporaryDeliveryOrderDetail.joins(:temporary_delivery_order, :item , :sales_order_detail).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( code  =~ query  )  
      }.count
    else
      @objects = TemporaryDeliveryOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = TemporaryDeliveryOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
