class Api::MemorialsController < Api::BaseApiController
  
  def index
     
     
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       @objects = Memorial.active_objects.where{
         (
           ( code =~ livesearch)  | 
           ( description =~ livesearch)  | 
           ( no_bukti =~  livesearch) 
         )

       }.page(params[:page]).per(params[:limit]).order("id DESC")

       @total = Memorial.active_objects.where{
         (
           ( code =~ livesearch)  | 
           ( description =~ livesearch)  | 
           ( no_bukti =~  livesearch) 
         )
       }.count
 

     else
       @objects = Memorial.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
       @total = Memorial.active_objects.count
     end
     
     
     
     
  end

  def create
    
    @object = Memorial.create_object( params[:memorial])
 
    if @object.errors.size == 0 
      
      render :json => { :success => true, 
                        :memorials => [
                          :id => @object.id, 
                          :code => @object.code ,
                          :description => @object.description , 
                          :amount => @object.amount  ,
                          :is_confirmed => @object.is_confirmed,
                          :confirmed_at => format_date_friendly(@object.confirmed_at) 
                          ] , 
                        :total => Memorial.active_objects.count }  
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
    @object  = Memorial.find params[:id]
    @total = Memorial.active_objects.count
  end

  def update
    params[:memorial][:confirmed_at] =  parse_date( params[:memorial][:confirmed_at] )
    
    @object = Memorial.find(params[:id])
    
    if params[:confirm].present?  
      if not current_user.has_menu_assignment?( :memorials, :confirm)
        render :json => {:success => false, :access_denied => "Tidak punya authorisasi"}
        return
      end
      
      begin
        ActiveRecord::Base.transaction do 
          @object.confirm_object(:confirmed_at => params[:memorial][:confirmed_at] ) 
        end
      rescue ActiveRecord::ActiveRecordError  
      else
      end
      
      
      
      
    elsif params[:unconfirm].present?    
      
      if not current_user.has_menu_assignment?( :memorials, :unconfirm)
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
      @object.update_object(params[:memorial])
    end
    
    if @object.errors.size == 0 
      @total = Memorial.active_objects.count
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
    @object = Memorial.find(params[:id])
    @object.delete_object

    if   not @object.persisted? 
      render :json => { :success => true, :total => Memorial.active_objects.count }  
    else
      render :json => { :success => false, :total => Memorial.active_objects.count, 
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
      @objects = Memorial.where{  
        ( 
           ( code =~ query)  | 
           ( description =~ query)  | 
           ( no_bukti =~  query) 
         )
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Memorial.where{  
        ( 
           ( code =~ query )  
         )
      }.count 
    else
      @objects = Memorial.where{ 
           ( code =~ query)  | 
           ( description =~ query)  | 
           ( no_bukti =~  query)    
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = Memorial.where{ 
          (id.eq selected_id)  
      }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
