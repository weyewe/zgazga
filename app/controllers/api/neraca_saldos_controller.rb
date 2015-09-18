class Api::NeracaSaldosController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = Closing.active_objects.where{
         (
           (( period =~ query)  | 
           ( year_period =~ query)) &
           (is_closed.eq true)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = Closing.active_objects.where{
         (
           (( period =~ query)  | 
           ( year_period =~ query)) &
           (is_closed.eq true)
         )
       }.count
 

     else
       @objects = Closing.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = Closing.active_objects.count
     end
    #   render :json => { :records => @objects , :total => @total, :success => true }
  end

  
  def show
    @object  = Closing.find params[:id]
    @total = Closing.active_objects.count
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
      @objects = Closing.where{  
        ( 
           (( period =~ query)  | 
           ( year_period =~ query)) &
           (is_closed.eq true)
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Closing.where{  
        ( 
           (( period =~ query)  | 
           ( year_period =~ query))  &
           (is_closed.eq true)
         )
      }.count 
    else
      @objects = Closing.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Closing.where{ 
          (id.eq selected_id)  
      }.count 
    end
     render :json => { :records => @objects , :total => @total, :success => true }
  end
end
