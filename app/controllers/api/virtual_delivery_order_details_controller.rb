class Api::VirtualDeliveryOrderDetailsController < Api::BaseApiController
  

  def parent_controller_name
      "virtual_delivery_orders"
  end
  
  def index
    @parent = VirtualDeliveryOrder.find_by_id params[:virtual_delivery_order_id]
    @objects = @parent.active_children.joins(:virtual_delivery_order, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = VirtualDeliveryOrder.find_by_id params[:virtual_delivery_order_id]
    
  
    @object = VirtualDeliveryOrderDetail.create_object(params[:virtual_delivery_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :virtual_delivery_order_details => [@object] , 
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
    @object = VirtualDeliveryOrderDetail.find_by_id params[:id] 
    @parent = @object.virtual_delivery_order 
    
    
    params[:virtual_delivery_order_detail][:virtual_delivery_order_id] = @parent.id  
    
    @object.update_object( params[:virtual_delivery_order_detail])
     
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
    @object = VirtualDeliveryOrderDetail.find(params[:id])
    @parent = @object.virtual_delivery_order 
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
      query_code = VirtualDeliveryOrderDetail.joins(:virtual_delivery_order, :item,:virtual_order_detail).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }
      
      if params[:virtual_delivery_order_id].present?
        object = VirtualDeliveryOrder.find_by_id params[:virtual_delivery_order_id]
        if not object.nil?  
          query = query.where(:virtual_delivery_order_id => object.id )
        end
      end    
      
      @objects = query_code.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = query_code.count
      
    else
      @objects = VirtualDeliveryOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = VirtualDeliveryOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
