class Api::CustomersController < Api::BaseApiController
   
    
    
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Contact.joins(:contact_group).customers.where{
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( delivery_address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( npwp =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( pic =~ livesearch ) | 
          ( pic_contact_no =~ livesearch ) | 
          ( email =~ livesearch ) | 
          ( tax_code =~ livesearch ) | 
          ( nama_faktur_pajak =~ livesearch ) | 
          ( contact_group.name =~ livesearch ) | 
          ( contact_group.description =~ livesearch )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Contact.joins(:contact_group).customers.where{  
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( delivery_address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( npwp =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( pic =~ livesearch ) | 
          ( pic_contact_no =~ livesearch ) | 
          ( email =~ livesearch ) | 
          ( tax_code =~ livesearch ) | 
          ( nama_faktur_pajak =~ livesearch ) | 
          ( contact_group.name =~ livesearch ) | 
          ( contact_group.description =~ livesearch )
        
      }.count
    else
      @objects = Contact.active_objects.customers.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Contact.active_objects.customers.count
    end
    
    
     
  end

  def create
    params[:customer][:contact_type] = CONTACT_TYPE[:customer] 
    @object = Contact.create_object( params[:customer] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :customers => [@object] , 
                        :total => Contact.active_objects.customers.count }  
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
    
    @object = Contact.find_by_id params[:id] 
    @object.update_object( params[:customer])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :customers => [@object],
                        :total => Contact.active_objects.customers.count  } 
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
    @object = Contact.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => Contact.active_objects.customers.count }  
    else
      render :json => { :success => false, :total => Contact.active_objects.customers.count }  
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
      @objects = Contact.active_objects.customers.where{ 
                        ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( delivery_address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( npwp =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( pic =~ livesearch ) | 
          ( pic_contact_no =~ livesearch ) | 
          ( email =~ livesearch ) | 
          ( tax_code =~ livesearch ) | 
          ( nama_faktur_pajak =~ livesearch ) | 
          ( contact_group.name =~ livesearch ) | 
          ( contact_group.description =~ livesearch )
                  }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Contact.active_objects.customers.where{ 
                        ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( delivery_address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( npwp =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( pic =~ livesearch ) | 
          ( pic_contact_no =~ livesearch ) | 
          ( email =~ livesearch ) | 
          ( tax_code =~ livesearch ) | 
          ( nama_faktur_pajak =~ livesearch ) | 
          ( contact_group.name =~ livesearch ) | 
          ( contact_group.description =~ livesearch )
                              }.count
    else
      @objects = Contact.active_objects.customers.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Contact.active_objects.customers.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
