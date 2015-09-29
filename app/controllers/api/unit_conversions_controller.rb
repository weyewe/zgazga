class Api::UnitConversionsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = UnitConversion.active_objects.where{
         (
           ( name =~ livesearch)  | 
           ( description =~ livesearch)  
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = UnitConversion.active_objects.where{
         (
           ( name =~ livesearch)  | 
           ( description =~ livesearch)  
         )
       }.count
 

     else
       @objects = UnitConversion.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = UnitConversion.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:unit_conversion][:transaction_datetime] =  parse_date( params[:unit_conversion][:transaction_datetime] )
    
    
    @object = UnitConversion.create_object( params[:unit_conversion])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :unit_conversions => [
                          :id => @object.id, 
                          :name => @object.name ,
                          :description => @object.description , 
                          :target_item_id => @object.target_item_id  ,
                          :target_amount => @object.target_amount
                          ] , 
                        :total => UnitConversion.active_objects.count }  
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
    @object  = UnitConversion.find params[:id]
    @total = UnitConversion.active_objects.count
  end

  def update
    params[:unit_conversion][:transaction_datetime] =  parse_date( params[:unit_conversion][:transaction_datetime] )
    params[:unit_conversion][:confirmed_at] =  parse_date( params[:unit_conversion][:confirmed_at] )
    
    @object = UnitConversion.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :unit_conversions, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:unit_conversion][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_menu_assignment?( :unit_conversions, :unconfirm)
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
      @object.update_object(params[:unit_conversion])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      @total = UnitConversion.active_objects.count
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
    @object = UnitConversion.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => UnitConversion.active_objects.count }  
    else
      render :json => { :success => false, :total => UnitConversion.active_objects.count, 
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
      @objects = UnitConversion.where{  
        ( 
            ( name =~ query)  | 
           ( description =~ query)  
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = UnitConversion.where{  
        ( 
            ( name =~ query)  | 
           ( description =~ query)  
         )
      }.count 
    else
      @objects = UnitConversion.where{ 
          (id.eq selected_id)   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = UnitConversion.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
