class Api::BlanketOrderDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "blanket_orders"
  end
  
  def index
    @parent = BlanketOrder.find_by_id params[:blanket_order_id]
    query = @parent.active_children.joins(:blanket_order, :blanket)
    
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( blanket.roll_no  =~ livesearch  )  
         )         
       } 
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = BlanketOrder.find_by_id params[:blanket_order_id]
    
  
    @object = BlanketOrderDetail.create_object(params[:blanket_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_order_details => [@object] , 
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
    @object = BlanketOrderDetail.find_by_id params[:id] 
    @parent = @object.blanket_order 
    
    
    params[:blanket_order_detail][:blanket_order_id] = @parent.id  
    
    @object.update_object( params[:blanket_order_detail])
     
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
    @object = BlanketOrderDetail.find(params[:id])
    @parent = @object.blanket_order 
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
      query_code = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
        # ( blanket.roll_no  =~ query  )   
      }
      
      if params[:blanket_order_id].present?
        object = BlanketOrder.find_by_id params[:blanket_order_id]
        object_id = object.id
        if not object.nil?  
          query_code = query_code.where{
            (blanket_order_id.eq object_id )
            # (is_finished.eq  true )
          }
        end
      end    
      
      
      @objects = query_code.
                      page(params[:page]).
                      per(params[:limit]).
                      order("id DESC")
                        
      @total = query_code.count
    else
      @objects = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
