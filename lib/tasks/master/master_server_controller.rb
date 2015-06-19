class Api::TemplatesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = Template.joins(:branch).where{
          (
            (name =~  livesearch ) | 
            (description =~ livesearch) | 
            (code =~ livesearch) |
            (branch.name =~ livesearch) | 
            (branch.code =~ livesearch)
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = Template.joins(:branch).where{
          (
            (name =~  livesearch ) | 
            (description =~ livesearch) |  
            (code =~ livesearch) |
            (branch.name =~ livesearch) | 
            (branch.code =~ livesearch)
          )
        }.count
   
    else
      puts "In this shite"
      @objects = Template.joins(:branch).page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Template.count 
    end
    
    
    # render :json => { :templates => @objects , :total => @total , :success => true }
  end

  def create
    @object = Template.create_object( params[:template] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :templates => [
                          
                            :id               =>    @object.id                  ,
                            :name       =>     @object.name   ,
                            :branch_id       =>     @object.branch.id   ,
                            :branch_code       =>     @object.branch.code   ,
                            :description    =>    @object.description  ,
                            :code        =>    @object.code     
                          ] , 
                        :total => Template.active_objects.count }  
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
    @object = Template.find(params[:id]) 
    

    @object.update_object( params[:template] )
    
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :templates => [
                          
                          :id               =>    @object.id                  ,
                          :name       =>     @object.name   ,
                          :description    =>    @object.description  ,
                          :branch_id       =>     @object.branch.id   ,
                          :branch_code       =>     @object.branch.code   ,

                          :code        =>    @object.code     
                          
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
  
  def show
    @object = Template.find_by_id params[:id]
    render :json => { :success => true, 
                      :templates => [@object] , 
                      :total => Template.count }
  end

  def destroy
    @object = Template.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Template.active_objects.count }  
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
      @objects = Template.where{ 

                           (
                              (name =~  livesearch ) | 
                              (description =~ livesearch) | 
                              (code =~ livesearch) 
                            )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Template.where{ (name =~ query)  
                              }.count
    else
      @objects = Template.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Template.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end