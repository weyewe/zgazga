class Api::RollerIdentificationFormDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "roller_identification_forms"
  end
  
  def index
    @parent = RollerIdentificationForm.find_by_id params[:roller_identification_form_id]
    query = @parent.active_children.joins(:roller_identification_form, :core_builder,:roller_type,:machine)
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
       
      query  = query.where{
        (
          ( core_builder.base_sku  =~ livesearch ) | 
          ( core_builder.name  =~ livesearch ) | 
          ( roller_type.name =~ livesearch ) | 
          ( machine.name  =~ livesearch  ) 
        )         
      } 
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = RollerIdentificationForm.find_by_id params[:roller_identification_form_id]
    
  
    @object = RollerIdentificationFormDetail.create_object(params[:roller_identification_form_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_identification_form_details => [@object] , 
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
    @object = RollerIdentificationFormDetail.find_by_id params[:id] 
    @parent = @object.roller_identification_form 
    
    
    params[:roller_identification_form_detail][:roller_identification_form_id] = @parent.id  
    
    @object.update_object( params[:roller_identification_form_detail])
     
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
    @object = RollerIdentificationFormDetail.find(params[:id])
    @parent = @object.roller_identification_form 
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
      query_code = RollerIdentificationFormDetail.joins(:roller_identification_form, :core_builder,:roller_type,:machine).where{ 
        ( core_builder.base_sku  =~ query ) | 
        ( core_builder.name  =~ query ) | 
        ( roller_type.name =~ query ) | 
        ( machine.name  =~ query  ) 
      }
      
      if params[:roller_identification_form_id].present?
        object = RollerIdentificationForm.find_by_id params[:roller_identification_form_id]
        if not object.nil?  
          query_code = query_code.where(:roller_identification_form_id => object.id )
        end
      end    
      
      @objects = query_code.
                page(params[:page]).
                per(params[:limit]).
                order("id DESC")
                        
      @total = query_code.count
    else
      @objects = RollerIdentificationFormDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RollerIdentificationFormDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
