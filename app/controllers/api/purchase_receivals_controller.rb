class Api::PurchaseReceivalsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PurchaseReceival.active_objects.joins(:contact,:employee,:exchange).where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PurchaseReceival.active_objects.joins(:contact,:employee,:exchange).where{
         (
            
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )
       }.count
 

     else
       @objects = PurchaseReceival.active_objects.joins(:contact,:employee,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PurchaseReceival.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:purchase_receival][:transaction_datetime] =  parse_date( params[:purchase_receival][:transaction_datetime] )
    
    
    @object = PurchaseReceival.create_object( params[:purchase_receival])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_receivals => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseReceival.active_objects.count }  
    else
      puts "It is fucking error!!\n"*10
      @object.errors.messages.each {|x| puts x }
      
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors ) 
          # :errors => {
          #   :name => "Nama tidak boleh bombastic"
          # }
        }
      }
      
      render :json => msg                         
    end
  end
  
  def show
    @object  = PurchaseReceival.find params[:id]
    render :json => { :success => true,   
                      :purchase_receivals => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at),
                          :contact_id => @object.contact_id,
                          :exchange_id => @object.exchange_id,
                          :employee_id => @object.employee_id
                        
                        ],
                      :total => PurchaseReceival.active_objects.count  }
  end

  def update
    params[:purchase_receival][:transaction_datetime] =  parse_date( params[:purchase_receival][:transaction_datetime] )
    params[:purchase_receival][:confirmed_at] =  parse_date( params[:purchase_receival][:confirmed_at] )
    
    @object = PurchaseReceival.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_receivals, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_receival][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_receivals, :unconfirm)
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
      @object.update_object(params[:purchase_receival])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_receivals => [
                            :id => @object.id,
                            :code => @object.code ,
                            :nomor_surat => @object.nomor_surat , 
                            :sales_date => format_date_friendly(@object.sales_date),
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at),
                            :contact_id => @object.contact_id,
                            :exchange_id => @object.exchange_id,
                            :employee_id => @object.employee_id
                          ],
                        :total => PurchaseReceival.active_objects.count  } 
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
    @object = PurchaseReceival.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseReceival.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseReceival.active_objects.count, 
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
      @objects = PurchaseReceival.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseReceival.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = PurchaseReceival.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseReceival.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
