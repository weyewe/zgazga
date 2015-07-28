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
  
  def update
   
    @parent = User.find_by_id params[:menu_detail][:user_id]
    @user = @parent 
    @menu = Menu.find_by_id params[:menu_detail][:id]
    # @object = MenuActionAssignment.create_object(params[:menu_detail])
    
    if params[:targetField].present?
      
      menu_action =  @menu.menu_actions.where(:action_name => params[:targetField]).first 
      
      menu_action_assignment = MenuActionAssignment.where(
          :menu_action_id => menu_action.id,
          :user_id => @user.id 
        ).first 
        
      if menu_action_assignment.present?
        menu_action_assignment.delete_object 
      else
        MenuActionAssignment.create_object(
          :menu_action_id => menu_action.id , 
          :user_id => @user.id 
          )
          
        
      end
      
    end
    
    
   
  end
  
  
 
end
