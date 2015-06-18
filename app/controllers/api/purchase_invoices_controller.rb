class Api::PurchaseInvoicesController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = PurchaseInvoice.active_objects.joins(:contact,:employee,:exchange).where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = PurchaseInvoice.active_objects.joins(:contact,:employee,:exchange).where{
         (
            
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( employee.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )
       }.count
 

     else
       @objects = PurchaseInvoice.active_objects.joins(:contact,:employee,:exchange).page(params[:page]).per(params[:limit]).order("id DESC")
       @total = PurchaseInvoice.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:purchase_invoice][:transaction_datetime] =  parse_date( params[:purchase_invoice][:transaction_datetime] )
    
    
    @object = PurchaseInvoice.create_object( params[:purchase_invoice])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_invoices => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :sales_date => format_date_friendly(@object.sales_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseInvoice.active_objects.count }  
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
    @object  = PurchaseInvoice.find params[:id]
    render :json => { :success => true,   
                      :purchase_invoices => [
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
                      :total => PurchaseInvoice.active_objects.count  }
  end

  def update
    params[:purchase_invoice][:transaction_datetime] =  parse_date( params[:purchase_invoice][:transaction_datetime] )
    params[:purchase_invoice][:confirmed_at] =  parse_date( params[:purchase_invoice][:confirmed_at] )
    
    @object = PurchaseInvoice.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_invoices, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_invoice][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_invoices, :unconfirm)
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
      @object.update_object(params[:purchase_invoice])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_invoices => [
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
                        :total => PurchaseInvoice.active_objects.count  } 
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
    @object = PurchaseInvoice.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseInvoice.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseInvoice.active_objects.count, 
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
      @objects = PurchaseInvoice.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseInvoice.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = PurchaseInvoice.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseInvoice.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
