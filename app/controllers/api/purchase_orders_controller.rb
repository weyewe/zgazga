class Api::PurchaseOrdersController < Api::BaseApiController
  
  def index
     
     
     query  = PurchaseOrder.active_objects.joins(:contact,:exchange)
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query = query.where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( exchange.name =~  livesearch)
         )

       }
        
     end
    
     
    if params[:is_filter].present?
      
      start_confirmation =  parse_date( params[:start_confirmation] )
      end_confirmation =  parse_date( params[:end_confirmation] )
      start_purchase_date =  parse_date( params[:start_purchase_date] )
      end_purchase_date =  parse_date( params[:end_purchase_date] )
      
      
      if params[:is_confirmed].present?
        query = query.where(:is_confirmed => true ) 
        if start_confirmation.present?
          query = query.where{ confirmed_at.gte start_confirmation}
        end
        
        if end_confirmation.present?
          query = query.where{ confirmed_at.lt  end_confirmation}
        end
      else
        query = query.where(:is_confirmed => false ) 
      end
    
      if start_purchase_date.present?
        query = query.where{ purchase_date.gte start_purchase_date}
      end
      
      if end_purchase_date.present?
        query = query.where{ purchase_date.lt  end_purchase_date}
      end
      
      object = Contact.find_by_id params[:contact_id]
      if not object.nil? 
        query = query.where(:contact_id => object.id )
      end
      
      object = Exchange.find_by_id params[:exchange_id]
      if not object.nil? 
        query = query.where(:exchange_id => object.id )
      end
      
      object = Employee.find_by_id params[:employee_id]
      if not object.nil? 
        query = query.where(:employee_id => object.id )
      end
    end
     
     @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count 
     
     
  end

  def create
    
    params[:purchase_order][:purchase_date] =  parse_date( params[:purchase_order][:purchase_date] )
    
    
    @object = PurchaseOrder.create_object( params[:purchase_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_orders => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat ,
                          :description => @object.description ,
                          :purchase_date => format_date_friendly(@object.purchase_date)  ,
                          :allow_edit_detail => @object.allow_edit_detail,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseOrder.active_objects.count }  
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
    @object  = PurchaseOrder.find params[:id]
    @total = PurchaseOrder.active_objects.count
  end

  def update
    params[:purchase_order][:purchase_date] =  parse_date( params[:purchase_order][:purchase_date] )
    params[:purchase_order][:confirmed_at] =  parse_date( params[:purchase_order][:confirmed_at] )
    
    @object = PurchaseOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :purchase_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_menu_assignment?( :purchase_orders, :unconfirm)
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
      @object.update_object(params[:purchase_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = PurchaseOrder.active_objects.count
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
    @object = PurchaseOrder.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseOrder.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseOrder.active_objects.count, 
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
      query_code = PurchaseOrder.where{  
        ( 
           ( code =~ query )  
         )
      }
      
      if params[:purchase_receival].present?
        query_code = query_code.where{
          (is_confirmed.eq true) &
          (is_receival_completed.eq false) 
        }
      end
      
      @objects = query_code.
            page(params[:page]).
            per(params[:limit]).
            order("id DESC")
                        
      @total = query_code.count 
    else
      @objects = PurchaseOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
