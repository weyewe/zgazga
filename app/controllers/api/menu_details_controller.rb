class Api::MenuDetailsController < Api::BaseApiController
  
  def index
    @parent = User.find_by_id params[:menu_id]
    query = Menu.includes(:menu_actions).order("id ASC")
    @objects = query.page(params[:page]).per(params[:limit]) 
    @total = query.count 
  end

  def create
   
    @parent = User.find_by_id params[:menu_id]
    @object = MenuActionAssignment.create_object(params[:menu_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :menu_details => [@object] , 
                        :total =>  MenuAction.count }  
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
    @object = MenuActionAssignment.find(params[:id]) 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => MenuAction.count }  
    else
      render :json => { :success => false, :total => MenuAction.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
      }  
    end
  end 
  
 
end
