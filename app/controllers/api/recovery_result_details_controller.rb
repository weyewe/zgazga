class Api::RecoveryResultDetailsController < Api::BaseApiController
  
  def index
    @parent = RecoveryResult.find_by_id params[:recovery_result_id]
    @objects = @parent.active_children.joins(:recovery_result, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RecoveryResult.find_by_id params[:recovery_result_id]
    
  
    @object = RecoveryResultDetail.create_object(params[:recovery_result_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :recovery_result_details => [@object] , 
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
    @object = RecoveryResultDetail.find_by_id params[:id] 
    @parent = @object.recovery_result 
    
    
    params[:recovery_result_detail][:recovery_result_id] = @parent.id  
    
    @object.update_object( params[:recovery_result_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :recovery_result_details => [@object],
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
    @object = RecoveryResultDetail.find(params[:id])
    @parent = @object.recovery_result 
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
      @objects = RecoveryResultDetail.joins(:recovery_result, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryResultDetail.joins(:recovery_result, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = RecoveryResultDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RecoveryResultDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
