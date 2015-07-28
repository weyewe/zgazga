class Api::MenusController < Api::BaseApiController
  
  def index
     
     query =  User.active_objects 
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       query = query.where{
         ( name =~ livesearch ) | 
         ( email =~ livesearch )
         
       }
 
     end
     
     @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count 
      
  end
 
end
