class Api::SalesDownPaymentsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = SalesDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{
          (
            ( code =~  livesearch )  | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = SalesDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{
          (
            ( code =~  livesearch )  | 
            ( contact.name =~ livesearch ) | 
            ( exchange.name =~ livesearch )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = SalesDownPayment.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = SalesDownPayment.count 
    end
    
    
    # render :json => { :sales_down_payments => @objects , :total => @total , :success => true }
  end

  def create
    params[:sales_down_payment][:down_payment_date] =  parse_date( params[:sales_down_payment][:down_payment_date] )
    @object = SalesDownPayment.create_object( params[:sales_down_payment] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :sales_down_payments => [@object] , 
                        :total => SalesDownPayment.active_objects.count  }  
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
    params[:sales_down_payment][:down_payment_date] =  parse_date( params[:sales_down_payment][:down_payment_date] )
    params[:sales_down_payment][:confirmed_at] =  parse_date( params[:sales_down_payment][:confirmed_at] )
    
    @object = SalesDownPayment.find(params[:id]) 
   
    if params[:confirm].present?  
      if not current_user.has_role?( :sales_down_payments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:sales_down_payment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :sales_down_payments, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
  else
    @object.update_object( params[:sales_down_payment] )
  end
     
    if @object.errors.size == 0 
      @total = SalesDownPayment.active_objects.count
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
  
  def show
    @object = SalesDownPayment.find_by_id params[:id]
    @total = SalesDownPayment.count
  end

  def destroy
    @object = SalesDownPayment.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => SalesDownPayment.active_objects.count }  
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
      
      query_code = SalesDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{ 
            ( code =~  query )  | 
            ( contact.name =~ query ) | 
            ( exchange.name =~ query ) | 
            ( is_confirmed.eq true )  
                              }
                              
      query_code = query_code.where{
              (is_confirmed.eq true)  &
              (payable_remaining_amount.gt 0)
            }
            
      @objects = query_code.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = query_code.count
    else
      @objects = SalesDownPayment.active_objects.joins(:contact,:exchange,:payable,:receivable).where{ (payable_id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = SalesDownPayment.where{ (payable_id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
