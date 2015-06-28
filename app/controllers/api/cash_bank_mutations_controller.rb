class Api::CashBankMutationsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = CashBankMutation.where{
          (
            ( name =~  livesearch )  | 
            ( address =~ livesearch ) | 
            ( description =~ livesearch ) | 
            ( contact_no =~ livesearch ) | 
            ( email =~ livesearch )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = CashBankMutation.where{
          (
            ( name =~  livesearch )  | 
            ( address =~ livesearch ) | 
            ( description =~ livesearch ) | 
            ( contact_no =~ livesearch ) | 
            ( email =~ livesearch )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = CashBankMutation.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = CashBankMutation.count 
    end
    
    
    # render :json => { :cash_bank_mutations => @objects , :total => @total , :success => true }
  end

  def create
    @object = CashBankMutation.create_object( params[:cash_bank_mutation] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :cash_bank_mutations => [@object] , 
                        :total => CashBankMutation.active_objects.count  }  
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
    @object = CashBankMutation.find(params[:id]) 
    

    @object.update_object( params[:cash_bank_mutation] )
    
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :cash_bank_mutations => [@object],
                        :total => CashBankMutation.active_objects.count } 
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
  
  def show
    @object = CashBankMutation.find_by_id params[:id]
    render :json => { :success => true, 
                      :cash_bank_mutations => [@object] , 
                      :total => CashBankMutation.count }
  end

  def destroy
    @object = CashBankMutation.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => CashBankMutation.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = CashBankMutation.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = CashBankMutation.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
        
                              }.count
    else
      @objects = CashBankMutation.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = CashBankMutation.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
