class Api::RecoveryResultCompoundDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "recovery_results"
  end
  
  def index
    @parent = RecoveryOrderDetail.find_by_id params[:recovery_result_id]
    query = @parent.active_compound_children.joins(:recovery_order_detail ,:batch_instance)
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( batch_instance)
         )         
       } 
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
    @parent = RecoveryOrderDetail.find_by_id params[:recovery_result_id]
    
  
    @object = CompoundUsage.create_object(params[:recovery_result_compound_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :recovery_result_compound_details => [@object] , 
                        :total => @parent.active_compound_children.count }  
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
    @object = CompoundUsage.find(params[:id])
    @parent = @object.recovery_order_detail
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_compound_children.count }  
    else
      render :json => { :success => false, :total => @parent.active_compound_children.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
      }  
    end
  end
   
  
 
end
