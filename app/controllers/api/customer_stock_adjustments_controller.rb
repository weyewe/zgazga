class Api::CustomerStockAdjustmentsController < Api::BaseApiController
  
  def index
     
     
     query = CustomerStockAdjustment.active_objects.joins(:warehouse,:contact)
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( warehouse.name =~  livesearch) |
           ( contact.name =~  livesearch) 
         )         
       } 
     end
     
     
    if params[:is_filter].present?
    # puts "after livesearch query total: #{query.count}" 
      start_confirmation =  parse_date( params[:start_confirmation] )
      end_confirmation =  parse_date( params[:end_confirmation] )
      start_adjustment_date =  parse_date( params[:start_adjustment_date] )
      end_adjustment_date =  parse_date( params[:end_adjustment_date] )
      
      
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
    
      if start_adjustment_date.present?
        query = query.where{ adjustment_date.gte start_adjustment_date}
      end
      
      if end_adjustment_date.present?
        query = query.where{ adjustment_date.lt end_adjustment_date}
      end
      
      object = Warehouse.find_by_id params[:warehouse_id]
      if not object.nil? 
        query = query.where(:warehouse_id => object.id )
      end 
      
      object = Contact.find_by_id params[:contact_id]
      if not object.nil? 
        query = query.where(:contact_id => object.id )
      end 
    end
     
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count 
     
     
     
     
  end

  def create
    
    params[:customer_stock_adjustment][:adjustment_date] =  parse_date( params[:customer_stock_adjustment][:adjustment_date] )
    
    
    @object = CustomerStockAdjustment.create_object( params[:customer_stock_adjustment])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :customer_stock_adjustments => [
                          :id => @object.id, 
                          :warehouse_id => @object.warehouse_id, 
                          :contact_id => @object.contact_id, 
                          :code => @object.code ,
                          :description => @object.description , 
                          :adjustment_date => format_date_friendly(@object.adjustment_date)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => CustomerStockAdjustment.active_objects.count }  
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
    @object  = CustomerStockAdjustment.find params[:id]
    @total = CustomerStockAdjustment.active_objects.count
  end

  def update
    params[:customer_stock_adjustment][:adjustment_date] =  parse_date( params[:customer_stock_adjustment][:adjustment_date] )
    params[:customer_stock_adjustment][:confirmed_at] =  parse_date( params[:customer_stock_adjustment][:confirmed_at] )
    
    @object = CustomerStockAdjustment.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :customer_stock_adjustments, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:customer_stock_adjustment][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_menu_assignment?( :customer_stock_adjustments, :unconfirm)
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
      @object.update_object(params[:customer_stock_adjustment])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = StockAdjustment.active_objects.count
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
    @object = CustomerStockAdjustment.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => CustomerStockAdjustment.active_objects.count }  
    else
      render :json => { :success => false, :total => CustomerStockAdjustment.active_objects.count, 
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
      @objects = CustomerStockAdjustment.where{  
        ( 
           ( code =~ query )  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = CustomerStockAdjustment.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = CustomerStockAdjustment.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = CustomerStockAdjustment.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
