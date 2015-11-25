class Api::RecoveryOrderDetailsController < Api::BaseApiController
  
  
  def parent_controller_name
      "recovery_orders"
  end
  
  
  def index
    @parent = RecoveryOrder.find_by_id params[:recovery_order_id]
    query = @parent.active_children.joins(:recovery_order, :roller_identification_form_detail,:roller_builder)
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( roller_builder.base_sku  =~ livesearch ) 
         )         
       } 
    end

    puts "the parent: #{@parent.id}"
    puts "parent's active children: #{@parent.active_children.count}"
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    puts "Total objects: #{@objects.count}"
    @total = query.count
  end

  def create
   
   puts "in the recovery order dtails\n"*100
    @parent = RecoveryOrder.find_by_id params[:recovery_order_id]
    
  
    @object = RecoveryOrderDetail.create_object(params[:recovery_order_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :recovery_order_details => [@object] , 
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
    @object = RecoveryOrderDetail.find_by_id params[:id] 
    @parent = @object.recovery_order 
    
    
    params[:recovery_order_detail][:recovery_order_id] = @parent.id  
    
    @object.update_object( params[:recovery_order_detail])
     
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
    @object = RecoveryOrderDetail.find(params[:id])
    @parent = @object.recovery_order 
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
      query_code = RecoveryOrderDetail.joins(:recovery_order, :roller_identification_form_detail,:roller_builder).where{ 
        ( roller_builder.base_sku  =~ query ) 
      }
      
      if params[:recovery_order_id].present?
        object = RecoveryOrder.find_by_id params[:recovery_order_id]
        object_id = object.id
        if not object.nil?  
          query_code = query_code.where{
            (recovery_order_id.eq object_id) &
            (is_finished.eq true)
          }
        end
        if params[:roller_warehouse_mutation_detail].present?
          query_code = query_code.where{
            (roller_identification_form_detail.is_delivered.eq false) 
          }
        end
      end    
      
      
      @objects = query_code.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = query_code.count
      
    else
      @objects = RecoveryOrderDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RecoveryOrderDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
