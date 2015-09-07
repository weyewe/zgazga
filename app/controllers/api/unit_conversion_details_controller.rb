class Api::UnitConversionDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "unit_conversions"
  end
  
  
  def index
    @parent = UnitConversion.find_by_id params[:unit_conversion_id]
    query = @parent.active_children.joins(:unit_conversion, :item => [:uom])
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
            ( item.sku  =~ livesearch ) | 
            ( item.name =~ livesearch ) | 
            ( item.uom.name  =~ livesearch  ) 
         )         
       } 
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = UnitConversion.find_by_id params[:unit_conversion_id]
    
  
    @object = UnitConversionDetail.create_object(params[:unit_conversion_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :unit_conversion_details => [@object] , 
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
    @object = UnitConversionDetail.find_by_id params[:id] 
    @parent = @object.unit_conversion 
    
    
    params[:unit_conversion_detail][:unit_conversion_id] = @parent.id  
    
    @object.update_object( params[:unit_conversion_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :unit_conversion_details => [@object],
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
    @object = UnitConversionDetail.find(params[:id])
    @parent = @object.unit_conversion 
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
      @objects = UnitConversionDetail.joins(:unit_conversion, :item => [:uom]).where{ 
          ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.uom.name  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = UnitConversionDetail.joins(:unit_conversion, :item => [:uom]).where{ 
          ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.uom.name  =~ query  ) 
      }.count
    else
      @objects = UnitConversionDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = UnitConversionDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
