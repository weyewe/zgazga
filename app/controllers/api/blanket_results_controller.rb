class Api::BlanketResultsController < Api::BaseApiController
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        query = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ blanket_order.is_confirmed.eq true }
        
        query = query.where{
          (
            ( blanket.contact.name  =~ livesearch ) | 
            ( blanket.machine.name =~ livesearch ) | 
            ( blanket.sku  =~ livesearch  )  | 
            ( blanket.name  =~ livesearch  )  
          ) 
        }
        @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = query.count
   
    else
      puts "In this shite"
      @objects = BlanketOrderDetail.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = BlanketOrderDetail.count 
    end
    
    
    # render :json => { :blanket_results => @objects , :total => @total , :success => true }
  end

  def create
    @object = BlanketOrderDetail.create_object( params[:blanket_work_process] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blanket_results => [@object] , 
                        :total => BlanketOrderDetail.active_objects.count  }  
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

  def update
    params[:blanket_result][:finished_at] =  parse_date( params[:blanket_result][:finished_at] )
    
    @object = BlanketOrderDetail.find(params[:id])
    
    if params[:finish].present?  
      if not current_user.has_role?( :blanket_order_details, :finish)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.finish_object(params[:blanket_result]) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unfinish].present?    
      
      if not current_user.has_role?( :blanket_order_details, :unfinish)
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
      
      
    else
      @object.update_object(params[:blanket_result])
    end
    
     
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :blanket_results => [@object],
                        :total => BlanketOrderDetail.active_objects.count } 
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
  
  def show
    @object = BlanketOrderDetail.find_by_id params[:id]
    render :json => { :success => true, 
                      :blanket_results => [@object] , 
                      :total => BlanketOrderDetail.count }
  end

  def destroy
    @object = BlanketOrderDetail.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => BlanketOrderDetail.active_objects.count }  
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
      @objects = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
          ( blanket.contact.name  =~ query ) | 
        ( blanket.machine.name =~ query ) | 
        ( blanket.sku  =~ query  )  | 
        ( blanket.name  =~ query  )  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ 
            ( blanket.contact.name  =~ query ) | 
        ( blanket.machine.name =~ query ) | 
        ( blanket.sku  =~ query  )  | 
        ( blanket.name  =~ query  )  
        
                              }.count
    else
      @objects = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = BlanketOrderDetail.joins(:blanket_order, :blanket).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
