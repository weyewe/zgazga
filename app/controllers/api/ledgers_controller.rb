class Api::LedgersController < Api::BaseApiController
  
  def index
     
    query = TransactionDataDetail.joins(:account, :transaction_data )
    
    
    
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        query = query.where{
          ( account.name =~ livesearch ) | 
          ( description =~ livesearch )
        }
    end
    
    if params[:is_filter].present?
    # puts "after livesearch query total: #{query.count}" 
      start_date =  parse_date( params[:start_date] )
      end_date =  parse_date( params[:end_date] ) 
      
      if start_date.present?
        query = query.where{ created_at.gte start_date}
      end
      
      if end_date.present?
        query = query.where{ created_at.lt end_date}
      end
    end
    
  
    
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count  
  end
  
  
  def show
    @object = Ledger.find_by_id params[:id]
    render :json => { :success => true, 
                      :ledgers => [@object] , 
                      :total => Ledger.count }
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
      @objects = Ledger.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Ledger.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
        
                              }.count
    else
      @objects = Ledger.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Ledger.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
