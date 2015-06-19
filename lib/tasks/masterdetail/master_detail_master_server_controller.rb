class Api::TemplatesController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = Template.active_objects.where{
         (is_deleted.eq false ) & 
         (
           (description =~  livesearch ) | 
           ( code =~ livesearch)
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = Template.active_objects.where{
         (is_deleted.eq false ) & 
         (
           (description =~  livesearch ) | 
            ( code =~ livesearch)
         )
       }.count
 

     else
       @objects = Template.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = Template.active_objects.count
     end
     
     
     
     
  end

  def create
    
    params[:template][:transaction_datetime] =  parse_date( params[:template][:transaction_datetime] )
    
    
    @object = Template.create_object( params[:template])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :templates => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :transaction_datetime => format_date_friendly(@object.transaction_datetime)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => Template.active_objects.count }  
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
    @object  = Template.find params[:id]
    render :json => { :success => true,   
                      :templates => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description ,
                          :transaction_datetime => format_date_friendly(@object.transaction_datetime)  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at)
                        
                        ],
                      :total => Template.active_objects.count  }
  end

  def update
    params[:template][:transaction_datetime] =  parse_date( params[:template][:transaction_datetime] )
    params[:template][:confirmed_at] =  parse_date( params[:template][:confirmed_at] )
    
    @object = Template.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_role?( :templates, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm(:confirmed_at => params[:template][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_role?( :templates, :unconfirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.unconfirm
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
    else
      @object.update_object(params[:template])
    end
    
     
    
    
    
    
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :templates => [
                            :id => @object.id,
                            :code => @object.code ,
                            :description => @object.description ,
                            :transaction_datetime => format_date_friendly(@object.transaction_datetime),
                            :is_confirmed => @object.is_confirmed,
                            :confirmed_at => format_date_friendly(@object.confirmed_at)
                          ],
                        :total => Template.active_objects.count  } 
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
    @object = Template.find(params[:id])
    @object.delete_object

    if (( not @object.persisted? )   or @object.is_deleted ) and @object.errors.size == 0
      render :json => { :success => true, :total => Template.active_objects.count }  
    else
      render :json => { :success => false, :total => Template.active_objects.count, 
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
      @objects = Template.where{  (title =~ query)   & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    else
      @objects = Template.where{ (id.eq selected_id)  & 
                                (is_deleted.eq false )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
    end
    
    
    render :json => { :records => @objects , :total => @objects.count, :success => true }
  end
end