class Api::BlanketResultDetailsController < Api::BaseApiController
  
  def index
    params[:blanket_detail_id] = params[:blanket_result_id]
    
    @parent = BlanketOrderDetail.find_by_id params[:blanket_result_id]
    
    if not @parent.nil?  and @parent.is_finished?
      @batch_source = @parent.batch_source
      query = @batch_source.batch_source_allocations.joins(:batch_instance)
      
      @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = query.count
    else
      @objects = [] 
      @total = 0
    end
    
  end

  def create
  
    @parent = BlanketOrderDetail.find_by_id params[:blanket_result_id]
    if not @parent.batch_source.nil?
      params[:batch_source_id] = @parent.batch_source.id 
    end
    
    
  
    @object = BatchSourceAllocation.create_object(params[:blanket_result_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_result_details => [@object] , 
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
  
  def destroy
    @object = BatchSourceAllocation.find(params[:id])
    @parent = @object.batch_source 
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
   
 
  
 
end
