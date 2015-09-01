class Api::BlanketOrdersController < Api::BaseApiController
  
  def index
     
     query = BlanketOrder.active_objects.joins(:contact, :warehouse)
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
        query = query.where{
         (
           ( code =~ livesearch)  | 
           ( production_no =~ livesearch)  | 
           ( contact.name =~  livesearch) | 
           ( warehouse.name =~  livesearch) | 
           ( notes =~  livesearch)
         )
        } 
     end
     
    
    if params[:is_filter].present? 
      start_confirmation =  parse_date( params[:start_confirmation] )
      end_confirmation =  parse_date( params[:end_confirmation] )
      start_order_date =  parse_date( params[:start_order_date] )
      end_order_date =  parse_date( params[:end_order_date] )
      start_due_date =  parse_date( params[:start_due_date] )
      end_due_date =  parse_date( params[:end_due_date] )
      
      
      if params[:is_confirmed].present?
        query = query.where(:is_confirmed => true ) 
        if start_confirmation.present?
          query = query.where{ confirmed_at.gte start_confirmation}
        end
        
        if end_confirmation.present?
          query = query.where{ confirmed_at.lt  end_confirmation }
        end
      else
        query = query.where(:is_confirmed => false )
      end
    
      if start_order_date.present?
        query = query.where{ order_date.gte start_order_date}
      end
      
      if end_order_date.present?
        query = query.where{ delivery_date.lt end_order_date}
      end
      
      if start_due_date.present?
        query = query.where{ due_date.gte start_due_date}
      end
      
      if end_due_date.present?
        query = query.where{ due_date.lt end_due_date}
      end
      
      object = Warehouse.find_by_id params[:warehouse_id]
      if not object.nil? 
        query = query.where(:warehouse_id => object.id )
      end
      
 
    end
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count   
      
  end

  def create
    
    params[:blanket_order][:order_date] =  parse_date( params[:blanket_order][:order_date] )
    params[:blanket_order][:due_date] =  parse_date( params[:blanket_order][:due_date] )
    
    
    @object = BlanketOrder.create_object( params[:blanket_order])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :blanket_orders => [
                         :id => @object.id, 
                            :code => @object.code ,
                            :order_date => format_date_friendly(@object.order_date)  ,
                            :production_no => @object.production_no,
                            :contact_id => @object.contact_id,
                            :contact_name => @object.contact.name,
                            :warehouse_id => @object.warehouse_id,
                            :warehouse_name => @object.warehouse.name,
                            :amount_final => @object.amount_final,
                            :amount_received => @object.amount_received,
                            :amount_rejected => @object.amount_rejected,
                            :has_due_date => @object.has_due_date,
                            :notes => @object.notes,
                            :due_date => format_date_friendly(@object.due_date),
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at),
                          ] , 
                        :total => BlanketOrder.active_objects.count }  
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
    @object  = BlanketOrder.find params[:id]
    @total = BlanketOrder.active_objects.count
  end

  def update
    params[:blanket_order][:order_date] =  parse_date( params[:blanket_order][:order_date] )
    params[:blanket_order][:due_date] =  parse_date( params[:blanket_order][:due_date] )
    params[:blanket_order][:confirmed_at] =  parse_date( params[:blanket_order][:confirmed_at] )
    
    @object = BlanketOrder.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :blanket_orders, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:blanket_order][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :blanket_orders, :unconfirm)
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
      @object.update_object(params[:blanket_order])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = BlanketOrder.active_objects.count
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
    @object = BlanketOrder.find(params[:id])
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end

    if not @object.persisted? 
      render :json => { :success => true, :total => BlanketOrder.active_objects.count }  
    else
     render :json => { :success => false, :total => BlanketOrder.active_objects.count, 
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
      query_code = BlanketOrder.active_objects.joins(:contact,:warehouse).where{  
        ( 
            ( code =~ query)  | 
            ( production_no =~ query)  | 
            ( contact.name =~  query) | 
            ( warehouse.name =~  query) | 
            ( notes =~  query)
         )
      }
      
      if params[:blanket_warehouse_mutation].present?
        query_code = query_code.where{
          (is_confirmed.eq true) 
          # (is_completed.eq false) 
        }
      end
      
      @objects = query_code.
                  page(params[:page]).
                  per(params[:limit]).
                  order("id DESC")
                        
      @total = query_code.count 
    else
      @objects = BlanketOrder.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = BlanketOrder.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
