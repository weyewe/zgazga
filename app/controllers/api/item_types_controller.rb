class Api::ItemTypesController < Api::BaseApiController
  
  def index
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = ItemType.where{  
        ( name =~ livesearch ) | 
        ( description =~ livesearch )
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = ItemType.where{ 
        ( name =~ livesearch  ) | 
        ( description =~ livesearch )
      }.count
      
      # calendar
      
    elsif params[:parent_id].present?
      # @group_loan = GroupLoan.find_by_id params[:parent_id]
      @objects = ItemType.
                  where(:item_type_id => params[:parent_id]).
                  page(params[:page]).per(params[:limit]).order("id DESC")
      @total = ItemType.where(:item_type_id => params[:parent_id]).count 
    else
      @objects = []
      @total = 0 
    end
    
    
    
    
    
    # render :json => { :item_types => @objects , :total => @total, :success => true }
  end

  def create
    @object = ItemType.create_object( params[:item_type] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :item_types => [@object] , 
                        :total => ItemType.active_objects.count }  
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
    
    @object = ItemType.find_by_id params[:id] 
    @object.update_object( params[:item_type])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :item_types => [@object],
                        :total => ItemType.active_objects.count  } 
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
    @object = ItemType.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => ItemType.active_objects.count }  
    else
      render :json => { :success => false, :total => ItemType.active_objects.count }  
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
      @objects = ItemType.joins(:item_type_type).where{ 
                            ( name =~ query ) | 
        ( description =~ query )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = ItemType.joins(:item_type_type).where{ 
              ( name =~ query ) | 
        ( description =~ query )
                              }.count
    else
      @objects = ItemType.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = ItemType.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
