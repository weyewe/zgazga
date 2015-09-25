class Api::PurchaseRequestDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "purchase_requests"
  end
  
  
  def index
    @parent = PurchaseRequest.find_by_id params[:purchase_request_id]
    query = @parent.active_children.joins(:purchase_request)
    
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
            ( uom  =~ livesearch ) | 
            ( name =~ livesearch ) | 
            ( description  =~ livesearch  )  | 
            ( code  =~ livesearch  )    
         )         
       } 
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = PurchaseRequest.find_by_id params[:purchase_request_id]
    
  
    @object = PurchaseRequestDetail.create_object(params[:purchase_request_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_request_details => [@object] , 
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
    @object = PurchaseRequestDetail.find_by_id params[:id] 
    @parent = @object.purchase_request 
    
    
    params[:purchase_request_detail][:purchase_request_id] = @parent.id  
    
    @object.update_object( params[:purchase_request_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_request_details => [@object],
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
    @object = PurchaseRequestDetail.find(params[:id])
    @parent = @object.purchase_request 
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
      @objects = PurchaseRequestDetail.where{ 
       
        ( name =~ query ) | 
        ( uom  =~ query  )  | 
        ( description  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseRequestDetail..where{ 
          ( name =~ query ) | 
          ( uom  =~ query  )  | 
          ( description  =~ query  )  
      }.count
    else
      @objects = PurchaseRequestDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PurchaseRequestDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
