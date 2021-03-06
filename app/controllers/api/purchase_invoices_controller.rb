class Api::PurchaseInvoicesController < Api::BaseApiController
  
  def index
     
    query = PurchaseInvoice.active_objects.
          joins(:purchase_receival =>[:contact,:exchange])
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query = query.where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( purchase_receival.code =~  livesearch) |
           ( purchase_receival.nomor_surat =~  livesearch)
         )         
       }   
     end
     
    
    if params[:is_filter].present?
        
      start_confirmation =  parse_date( params[:start_confirmation] )
      end_confirmation =  parse_date( params[:end_confirmation] )
      start_invoice_date =  parse_date( params[:start_invoice_date] )
      end_invoice_date =  parse_date( params[:end_invoice_date] )
      
       
      
      if params[:is_confirmed].present?
        query = query.where(:is_confirmed => true ) 
        if  start_confirmation.present?
          query = query.where{ confirmed_at.gte start_confirmation }
        end
        
        if end_confirmation.present?
          query = query.where{ confirmed_at.lt  end_confirmation }
        end
      else
        query = query.where(:is_confirmed => false )
      end
    
      if start_invoice_date.present?
        query = query.where{ invoice_date.gte start_invoice_date}
      end
      
      if end_invoice_date.present?
        query = query.where{ invoice_date.lt end_invoice_date}
      end
      
      object = PurchaseReceival.find_by_id params[:purchase_receival_id]
      if not object.nil? 
        query = query.where(:purchase_receival_id => object.id )
      end
    end
     
     
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
     
  end

  def create
    
    params[:purchase_invoice][:invoice_date] =  parse_date( params[:purchase_invoice][:invoice_date] )
    
    
    @object = PurchaseInvoice.create_object( params[:purchase_invoice])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_invoices => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :nomor_surat => @object.nomor_surat ,
                          :invoice_date => format_date_friendly(@object.invoice_date)  ,
                          :due_date => format_date_friendly(@object.due_date)  ,
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
    @total = PurchaseInvoice.active_objects.count
  end

  def update
    params[:purchase_invoice][:invoice_date] =  parse_date( params[:purchase_invoice][:invoice_date] )
    params[:purchase_invoice][:confirmed_at] =  parse_date( params[:purchase_invoice][:confirmed_at] )
    
    @object = PurchaseInvoice.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :purchase_invoices, :confirm)
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
      
      if not current_user.has_menu_assignment?( :purchase_invoices, :unconfirm)
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
      @total = PurchaseInvoice.active_objects.count
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
