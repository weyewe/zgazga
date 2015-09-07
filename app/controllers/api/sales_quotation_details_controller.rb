class Api::SalesQuotationDetailsController < Api::BaseApiController
  
  def index
    @parent = SalesQuotation.find_by_id params[:sales_quotation_id]
    query = @parent.active_children.joins(:sales_quotation, :item => [:uom])
    
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
   
    @parent = SalesQuotation.find_by_id params[:sales_quotation_id]
    
  
    @object = SalesQuotationDetail.create_object(params[:sales_quotation_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sales_quotation_details => [@object] , 
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
    @object = SalesQuotationDetail.find_by_id params[:id] 
    @parent = @object.sales_quotation 
    
    
    params[:sales_quotation_detail][:sales_quotation_id] = @parent.id  
    
    @object.update_object( params[:sales_quotation_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :sales_quotation_details => [@object],
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
    @object = SalesQuotationDetail.find(params[:id])
    @parent = @object.sales_quotation 
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
      @objects = SalesQuotationDetail.joins(:sales_quotation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesQuotationDetail.joins(:sales_quotation, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = SalesQuotationDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = SalesQuotationDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
