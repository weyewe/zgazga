class Api::SalesQuotationsController < Api::BaseApiController
  
  def index
     
     query_code = SalesQuotation.active_objects.joins(:contact)
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       query_code = query_code.where{
         (
           
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( version_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( description =~  livesearch)
         )

       }
      end

      if params[:is_filter].present? 
        start_confirmation =  parse_date( params[:start_confirmation] )
        end_confirmation =  parse_date( params[:end_confirmation] )
        start_quotation_date =  parse_date( params[:start_quotation_date] )
        end_quotation_date =  parse_date( params[:end_quotation_date] )
      
      
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
      
        if params[:is_approved].present?
          query_code = query_code.where(:is_approved => true ) 
        else
          query_code = query_code.where(:is_approved => false )
        end
      
        if params[:is_rejected].present?
          query_code = query_code.where(:is_rejected => true ) 
        else
          query_code = query_code.where(:is_rejected => false )
        end
      
        if start_quotation_date.present?
          query_code = query_code.where{ quotation_date.gte start_quotation_date}
        end
        
        if end_quotation_date.present?
          query_code = query_code.where{ quotation_date.lt end_quotation_date}
        end
      
        object = Contact.find_by_id params[:contact_id]
        if not object.nil? 
          query_code = query_code.where(:contact_id => object.id )
        end
      end
    
       @objects = query_code.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = query_code.count
     
  end

  def create
    
    params[:sales_quotation][:quotation_date] =  parse_date( params[:sales_quotation][:quotation_date] )
    
    
    @object = SalesQuotation.create_object( params[:sales_quotation])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :sales_quotations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :contact_id => @object.contact_id ,
                          :nomor_surat => @object.nomor_surat , 
                          :version_no => @object.version_no , 
                          :description => @object.description , 
                          :total_quote_amount => @object.total_quote_amount , 
                          :total_rrp_amount => @object.total_rrp_amount , 
                          :cost_saved => @object.cost_saved , 
                          :percentage_saved => @object.percentage_saved , 
                          :quotation_date => format_date_friendly(@object.quotation_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :is_approved => @object.is_approved,
                          :is_rejected => @object.is_rejected,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => SalesQuotation.active_objects.count }  
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
    @object  = SalesQuotation.find params[:id]
    render :json => { :success => true,   
                      :sales_quotations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :contact_id => @object.contact_id ,
                          :nomor_surat => @object.nomor_surat , 
                          :version_no => @object.version_no , 
                          :description => @object.description , 
                          :total_quote_amount => @object.total_quote_amount , 
                          :total_rrp_amount => @object.total_rrp_amount , 
                          :cost_saved => @object.cost_saved , 
                          :percentage_saved => @object.percentage_saved , 
                          :quotation_date => format_date_friendly(@object.quotation_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :is_approved => @object.is_approved,
                          :is_rejected => @object.is_rejected,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                        
                        ],
                      :total => SalesQuotation.active_objects.count  }
  end

  def update
    params[:sales_quotation][:transaction_datetime] =  parse_date( params[:sales_quotation][:transaction_datetime] )
    params[:sales_quotation][:confirmed_at] =  parse_date( params[:sales_quotation][:confirmed_at] )
    
    @object = SalesQuotation.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :sales_quotations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:sales_quotation][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :sales_quotations, :unconfirm)
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
      
    elsif params[:approve].present?    
      
      if not current_user.has_role?( :sales_quotations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.approve_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
    
       
    elsif params[:reject].present?    
      
      if not current_user.has_role?( :sales_quotations, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.reject_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
        
    else
      @object.update_object(params[:sales_quotation])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :sales_quotations => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :contact_id => @object.contact_id ,
                          :nomor_surat => @object.nomor_surat , 
                          :version_no => @object.version_no , 
                          :description => @object.description , 
                          :total_quote_amount => @object.total_quote_amount , 
                          :total_rrp_amount => @object.total_rrp_amount , 
                          :cost_saved => @object.cost_saved , 
                          :percentage_saved => @object.percentage_saved , 
                          :quotation_date => format_date_friendly(@object.quotation_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :is_approved => @object.is_approved,
                          :is_rejected => @object.is_rejected,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ],
                        :total => SalesQuotation.active_objects.count  } 
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
    @object = SalesQuotation.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => SalesQuotation.active_objects.count }  
    else
      render :json => { :success => false, :total => SalesQuotation.active_objects.count, 
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
      query_code = SalesQuotation.active_objects.joins(:contact).where{  
        ( 
           ( code =~ query)  | 
           ( nomor_surat =~ query)  | 
           ( version_no =~ query)  | 
           ( contact.name =~  query) | 
           ( description =~  query)
         )
      }
      @objects = query_code.
                  page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
                                    
      @total = query_code.count 
    else
      @objects = SalesQuotation.active_objects.joins(:contact).where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = SalesQuotation.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
