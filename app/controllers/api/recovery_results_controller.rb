class Api::RecoveryResultsController < Api::BaseApiController
  
  def index
     
     
    query = RecoveryOrderDetail.active_objects.joins(:recovery_order, :roller_identification_form_detail,:roller_builder)
    
    query = query.where{
      (recovery_order.is_confirmed.eq true)
    }
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      
      query = query.where{
        ( 
          ( code =~ livesearch)  | 
          ( nomor_surat =~ livesearch)  | 
          ( contact.name =~  livesearch) | 
          ( employee.name =~  livesearch) | 
          ( exchange.name =~  livesearch)
        )      
      } 
    end
     
    if params[:is_filter].present? 
      start_finished_date =  parse_date( params[:start_finished_date] )
      end_finished_date =  parse_date( params[:end_finished_date] )
      
      start_rejected_date =  parse_date( params[:start_rejected_date] )
      end_rejected_date =  parse_date( params[:end_rejected_date] )
      
      if params[:is_finished].present? 
        query = query.where(:is_finished => true )
        if start_finished_date.present?
          
          query = query.where{ finished_date.gte start_finished_date}
        end
        
        if end_finished_date.present?
          query = query.where{ finished_date.lt end_finished_date}
        end
      elsif params[:is_rejected].present?
        query = query.where(:is_rejected => true )
        if start_rejected_date.present?
          query = query.where{ rejected_date.gte start_rejected_date}
        end
        
        if end_rejected_date.present?
          query = query.where{ rejected_date.lt end_rejected_date}
        end
      else
        query = query.where(:is_rejected => false, :is_finished => false )
      end
       
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
      
  end
 
  
  def show
    @object  = RecoveryOrderDetail.find params[:id]
    @total = RecoveryOrderDetail.joins(:recovery_order).where{ recovery_order.is_confirmed.eq true }
  end

  def update
    params[:recovery_result][:finished_date] =  parse_date( params[:recovery_result][:finished_date] )
    params[:recovery_result][:rejected_date] =  parse_date( params[:recovery_result][:rejected_date] )
    params[:recovery_result][:confirmed_at] =  parse_date( params[:recovery_result][:confirmed_at] )
    
    @object = RecoveryOrderDetail.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :recovery_results, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:recovery_result][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_menu_assignment?( :recovery_results, :unconfirm)
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
    elsif params[:finish].present?    
      
      if not current_user.has_menu_assignment?( :recovery_results, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.finish_object(  params[:recovery_result] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
    elsif params[:unfinish].present?    
      
      if not current_user.has_menu_assignment?( :recovery_results, :unfinish)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unfinish_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end 
      
      
    elsif params[:reject].present?    
      
      if not current_user.has_menu_assignment?( :recovery_results, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.reject_object(  params[:recovery_result] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
    elsif params[:unreject].present?    
      
      if not current_user.has_menu_assignment?( :recovery_results, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unreject_object
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end 
      
      
    else
      @object.process_object(params[:recovery_result])
    end
    
     
    
    
    
    @total = RecoveryOrderDetail.joins(:recovery_order).where{ recovery_order.is_confirmed.eq true }
    if @object.errors.size == 0 
    
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
    @object = RecoveryOrderDetail.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => RecoveryOrderDetail.active_objects.count }  
    else
      render :json => { :success => false, :total => RecoveryOrderDetail.active_objects.count, 
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
      @objects = RecoveryOrderDetail.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrderDetail.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = RecoveryOrderDetail.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RecoveryOrderDetail.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
