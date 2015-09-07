class Api::ReceivablesController < Api::BaseApiController
  
  def index
     
    query = Receivable.active_objects.joins(:exchange,:contact)     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        query = query.where{ 
          (
            ( source_class =~  livesearch )  | 
            ( source_code =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          ) 
        }
   
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total  = query.count
    
    # render :json => { :receivables => @objects , :total => @total , :success => true }
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
      query_code = Receivable.joins(:exchange,:contact).where{ 
          ( source_class =~  query )  | 
          ( source_code =~ query ) | 
          ( contact.name =~ query ) | 
          ( exchange.name =~ query ) 
                              }
                              
      if params[:contact_id].present?
        object = Contact.find_by_id params[:contact_id] 
        if not object.nil?  
          query_code = query_code.where{  
            ( 
               ( contact_id.eq object.id )  &
               ( is_completed.eq false )  
            )
          }
        end
      end    
      
      @objects = query_code.page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
      @total = query_code.count 
    else
      @objects = Receivable.joins(:exchange,:contact).where{ 
          (id.eq selected_id) 
          # (is_completed.eq false)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Receivable.joins(:exchange,:contact).where{ 
        (id.eq selected_id) 
        # (is_completed.eq false)  
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end