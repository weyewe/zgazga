class Api::SalesDowmPaymentAllocationDetailsController < Api::BaseApiController
  
  def index
    @parent = SalesDowmPaymentAllocation.find_by_id params[:sales_dowm_payment_allocation_id]
    @objects = @parent.active_children.joins(:sales_dowm_payment_allocation, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = SalesDowmPaymentAllocation.find_by_id params[:sales_dowm_payment_allocation_id]
    
  
    @object = SalesDowmPaymentAllocationDetail.create_object(params[:sales_dowm_payment_allocation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sales_dowm_payment_allocation_details => [@object] , 
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
    @object = SalesDowmPaymentAllocationDetail.find_by_id params[:id] 
    @parent = @object.sales_dowm_payment_allocation 
    
    
    params[:sales_dowm_payment_allocation_detail][:sales_dowm_payment_allocation_id] = @parent.id  
    
    @object.update_object( params[:sales_dowm_payment_allocation_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :sales_dowm_payment_allocation_details => [@object],
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
    @object = SalesDowmPaymentAllocationDetail.find(params[:id])
    @parent = @object.sales_dowm_payment_allocation 
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
      @objects = SalesDowmPaymentAllocationDetail.joins(:sales_dowm_payment_allocation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesDowmPaymentAllocationDetail.joins(:sales_dowm_payment_allocation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = SalesDowmPaymentAllocationDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = SalesDowmPaymentAllocationDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
