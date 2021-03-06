class Api::DeliveryOrderDetailsController < Api::BaseApiController
  
  
  def parent_controller_name
      "delivery_orders"
  end
  
  
  def index
    @parent = DeliveryOrder.find_by_id params[:delivery_order_id]
    query = @parent.active_children.joins(:delivery_order, :item => [:uom])
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
            ( item.sku  =~ livesearch ) | 
            ( item.name =~ livesearch ) | 
            ( item.description  =~ livesearch  )  | 
            ( code  =~ livesearch  )  
         )         
       } 
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = DeliveryOrder.find_by_id params[:delivery_order_id]
    
  
    @object = DeliveryOrderDetail.create_object(params[:delivery_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :delivery_order_details => [@object] , 
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
    @object = DeliveryOrderDetail.find_by_id params[:id] 
    @parent = @object.delivery_order 
    
    
    params[:delivery_order_detail][:delivery_order_id] = @parent.id  
    
    @object.update_object( params[:delivery_order_detail])
     
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
    @object = DeliveryOrderDetail.find(params[:id])
    @parent = @object.delivery_order 
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
      
      query_code = DeliveryOrderDetail.joins(:delivery_order, :item,:sales_order_detail).where{ 
          ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
                              }
                              
      if params[:delivery_order_id].present?
        object = DeliveryOrder.find_by_id params[:delivery_order_id]
        if not object.nil?  
          query_code = query_code.where{
            (delivery_order_id.eq object.id ) & 
            (pending_invoiced_amount.gt 0)
          }
        end
      end    
      
      # @objects = DeliveryOrderDetail.joins(:delivery_order, :item,:sales_order_detail).where{ 
      #     ( item.sku  =~ query ) | 
      #   ( item.name =~ query ) | 
      #   ( item.description  =~ query  )  | 
      #   ( code  =~ query  )  
      # }.
      # page(params[:page]).
      # per(params[:limit]).
      # order("id DESC")
                        
      # @total = DeliveryOrderDetail.joins(:delivery_order, :item,:sales_order_detail).where{ 
      #     ( item.sku  =~ query ) | 
      #   ( item.name =~ query ) | 
      #   ( item.description  =~ query  )  | 
      #   ( code  =~ query  )  
      # }.count
      
      @objects = query_code.page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
      @total = query_code.count 
    else
      @objects = DeliveryOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = DeliveryOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
