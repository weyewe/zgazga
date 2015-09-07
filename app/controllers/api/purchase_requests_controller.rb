class Api::PurchaseRequestsController < Api::BaseApiController
  
  def index
     
     query_code = PurchaseRequest.active_objects
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       query_code = query_code.where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  
         )

       }
      end

      if params[:is_filter].present? 
        start_confirmation =  parse_date( params[:start_confirmation] )
        end_confirmation =  parse_date( params[:end_confirmation] )
        start_request_date =  parse_date( params[:start_request_date] )
        end_request_date =  parse_date( params[:end_request_date] )
      
      
        if params[:is_confirmed].present?
          query_code = query_code.where(:is_confirmed => true ) 
          if start_confirmation.present?
            query_code = query_code.where{ confirmed_at.gte start_confirmation}
          end
          if end_confirmation.present?
            query_code = query_code.where{ confirmed_at.lt  end_confirmation }
          end
        else
          query_code = query_code.where(:is_confirmed => false )
        end
      
        if start_request_date.present?
          query_code = query_code.where{ request_date.gte start_request_date}
        end
        
        if end_request_date.present?
          query_code = query_code.where{ request_date.lt end_request_date}
        end
      
      end
    
       @objects = query_code.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = query_code.count
     
     
     
  end

  def create
    
    params[:purchase_request][:transaction_datetime] =  parse_date( params[:purchase_request][:transaction_datetime] )
    
    
    @object = PurchaseRequest.create_object( params[:purchase_request])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :purchase_requests => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :request_date => format_date_friendly(@object.request_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => PurchaseRequest.active_objects.count }  
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
    @object  = PurchaseRequest.find params[:id]
    render :json => { :success => true,   
                      :purchase_requests => [
                         :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :request_date => format_date_friendly(@object.request_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => PurchaseRequest.active_objects.count  }
  end

  def update
    params[:purchase_request][:transaction_datetime] =  parse_date( params[:purchase_request][:transaction_datetime] )
    params[:purchase_request][:confirmed_at] =  parse_date( params[:purchase_request][:confirmed_at] )
    
    @object = PurchaseRequest.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :purchase_requests, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:purchase_request][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :purchase_requests, :unconfirm)
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
      @object.update_object(params[:purchase_request])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_requests => [
                            :id => @object.id, 
                          :code => @object.code ,
                          :nomor_surat => @object.nomor_surat , 
                          :request_date => format_date_friendly(@object.request_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => PurchaseRequest.active_objects.count  } 
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
    @object = PurchaseRequest.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => PurchaseRequest.active_objects.count }  
    else
      render :json => { :success => false, :total => PurchaseRequest.active_objects.count, 
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
      @objects = PurchaseRequest.where{  
        ( 
           ( code =~ query )  |
           ( nomor_surat =~ query )
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseRequest.where{  
        ( 
           ( code =~ query )  |
           ( nomor_surat =~ query )
         )
      }.count 
    else
      @objects = PurchaseRequest.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PurchaseRequest.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
