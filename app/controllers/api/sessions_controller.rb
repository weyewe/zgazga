class Api::SessionsController < Api::BaseApiController
  before_filter :authenticate_user!, :except => [:create, :destroy, :say_hi ]
  # skip_before_filter :authenticate_auth_token, :only => [:create, :destroy, :say_hi ]
  
  skip_before_filter :authenticate_user_from_token!, :only => [:create, :destroy, :say_hi ]
  
  
  
  skip_before_filter :ensure_authorized, :only => [:create, :destroy, :say_hi ]
  
  
  before_filter :ensure_params_exist, :except => [:say_hi, :destroy, :authenticate_auth_token]

  respond_to :json

  def create
    
     
    resource = User.find_for_database_authentication(:email => params[:user_login][:email])
    return invalid_login_attempt unless resource
    
 
    if resource.valid_password?(params[:user_login][:password])
      sign_in(:user, resource)
      resource.ensure_authentication_token
      
      role_object = {}
      
      if resource.is_admin?
        role_object[:system] = {:administrator => true }
      end
      
      MenuActionAssignment.joins(:menu_action => [:menu]).where{
        ( user_id.eq resource.id )  & 
        ( menu_action.action_name.eq "index")
      }.each do |menu_action_assignment| 
        role_object[menu_action_assignment.menu_action.menu.controller_name.to_sym] = {:index => true }
      end
       
      render :json=> {:success=>true, 
                      :auth_token=>resource.authentication_token, 
                      :email=>resource.email,
                      # :role => resource.role.the_role.to_json
                      :role => role_object.to_json
              }
      return
    end
    
    invalid_login_attempt
  end
  
  def say_hi
    render :json=> {:success=>true, 
                    :msg => "Server: This is your coffee!"
            }
  end
  
  def authenticate_auth_token
    render :json => {:success => true }
  end
 
  def destroy
    # resource = User.find_for_database_authentication(:email => params[:user_login][:email])
    resource = User.find_by_authentication_token( params[:auth_token])
    if resource
      resource.authentication_token = nil
    end
    # resource.save
    
    if resource and resource.save
      render :json=> {:success=>true}
    else
      render :json=> {:success=>false}
    end
    
  end
 
  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end