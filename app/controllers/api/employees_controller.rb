class Api::EmployeesController < Api::BaseApiController
   
    
    
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Employee.where{
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Employee.where{  
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
        
      }.count
    else
      @objects = Employee.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Employee.active_objects.count
    end
    
    
     
  end

  def create
    params[:employee][:contact_type] = CONTACT_TYPE[:employee] 
    @object = Employee.create_object( params[:employee] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :employees => [@object] , 
                        :total => Employee.active_objects.count }  
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
    
    @object = Employee.find_by_id params[:id] 
    @object.update_object( params[:employee])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :employees => [@object],
                        :total => Employee.active_objects.count  } 
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
    @object = Employee.find(params[:id])
    @object.delete_object

    if not @object.persisted?
      render :json => { :success => true, :total => Employee.active_objects.count }  
    else
      render :json => { :success => false, :total => Employee.active_objects.count }  
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
      @objects = Employee.active_objects.where{ 
                        ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
                  }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Employee.active_objects.where{ 
                        ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
                              }.count
    else
      @objects = Employee.active_objects.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Employee.active_objects.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
