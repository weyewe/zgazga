class Api::PurchaseOrderDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "purchase_orders"
  end
  
  def index
    @parent = PurchaseOrder.find_by_id params[:purchase_order_id]
    query = @parent.active_children.joins(:purchase_order, :item => [:uom]).page(params[:page])
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
    
    @objects = query.per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = PurchaseOrder.find_by_id params[:purchase_order_id]
    
  
    @object = PurchaseOrderDetail.create_object(params[:purchase_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_order_details => [@object] , 
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
    @object = PurchaseOrderDetail.find_by_id params[:id] 
    @parent = @object.purchase_order 
    
    
    params[:purchase_order_detail][:purchase_order_id] = @parent.id  
    
    @object.update_object( params[:purchase_order_detail])
     
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
    @object = PurchaseOrderDetail.find(params[:id])
    @parent = @object.purchase_order 
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
      query_code =  PurchaseOrderDetail.joins(:purchase_order, :item => [:uom]).where{ 
            ( item.sku  =~ query ) | 
            ( item.name =~ query ) | 
            ( item.description  =~ query  )  | 
            ( code  =~ query  )  
      }
      
      if params[:purchase_order_id].present?
        object = PurchaseOrder.find_by_id params[:purchase_order_id]
        if not object.nil?  
          query_code = query_code.where(:purchase_order_id => object.id )
        end
      end    
      
      @objects = query_code.
                page(params[:page]).
                per(params[:limit]).
                order("id DESC")
                        
      @total = query_code.count
    else
      @objects = PurchaseOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PurchaseOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
