class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    tenant_outstanding_invoice_url 
  end

  def after_sign_out_path_for( resource )
  	root_url
  end


  def validate_auth_token
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
  end

  protect_from_forgery with: :exception
  
  def parse_date( date_string) 
    return nil if not date_string.present?
    # puts "'The date_string: ' :#{date_string}"
    date_array = date_string.split('-').map{|x| x.to_i}
     
     
    # puts "inside parse date\n"*10
    # puts "0: #{date_array[0]}"
    # puts "0: #{date_array[1]}"
    # puts "0: #{date_array[2]}"
    # puts "\n\n"
   
    datetime = DateTime.new( date_array[0], 
                              date_array[1], 
                              date_array[2], 
                               0, 
                               0, 
                               0,
                  Rational( UTC_OFFSET , 24) )
                  
                  
    return datetime.utc
  end
end
