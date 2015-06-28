class Api::BlanketWorkOrderDetailsController < Api::BaseApiController
  
  def index
    @parent = BlanketWorkOrder.find_by_id params[:blanket_work_order_id]
    @objects = @parent.active_children.joins(:blanket_work_order, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = BlanketWorkOrder.find_by_id params[:blanket_work_order_id]
    
  
    @object = BlanketWorkOrderDetail.create_object(params[:blanket_work_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_work_order_details => [@object] , 
                        :total => @parent.active_children.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    @object = BlanketWorkOrderDetail.find_by_id params[:id] 
    @parent = @object.blanket_work_order 
    
    
    params[:blanket_work_order_detail][:blanket_work_order_id] = @parent.id  
    
    @object.update_object( params[:blanket_work_order_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :blanket_work_order_details => [@object],
                        :total => @parent.active_children.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = BlanketWorkOrderDetail.find(params[:id])
    @parent = @object.blanket_work_order 
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
      @objects = BlanketWorkOrderDetail.joins(:blanket_work_order, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketWorkOrderDetail.joins(:blanket_work_order, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = BlanketWorkOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = BlanketWorkOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
