class Api::CashBanksController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = CashBank.joins(:exchange).where{ 
        (
          (name =~  livesearch ) | 
          (description =~  livesearch ) |
          ( exchange.name =~ livesearch )
           
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = CashBank.joins(:exchange).where{
        (
          (name =~  livesearch ) | 
          (description =~  livesearch )  |
          ( exchange.name =~ livesearch )
        )
        
      }.count
    else
      @objects = CashBank.active_objects.joins(:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashBank.active_objects.count
    end
    
    
    
    # render :json => { :cash_banks => @objects , :total => @total, :success => true }
  end

  def create
    @object = CashBank.create_object( params[:cash_bank] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :cash_banks => [@object] , 
                        :total => CashBank.active_objects.count }  
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
    
    @object = CashBank.find_by_id params[:id] 
    @object.update_object( params[:cash_bank])
     
    if @object.errors.size == 0 
      @total = CashBank.active_objects.count
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
    @object = CashBank.find(params[:id])
    @object.delete_object

    if not @object.persisted?
      render :json => { :success => true, :total => Uom.active_objects.count }  
    else
      render :json => { :success => false, :total => Uom.active_objects.count,
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
      @objects = CashBank.active_objects.joins(:exchange).where{
                                (
                                  (name =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashBank.active_objects.where{ 
                                (
                                  (name =~  query ) | 
                                  (description =~  query ) 
                                )
                              }.count
    else
      @objects = CashBank.active_objects.joins(:exchange).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashBank.active_objects.joins(:exchange).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
