class Api::TransactionDatasController < Api::BaseApiController
  
  def index
     
     query = TransactionData 
     if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       query = query.where{
         ( transaction_source_type =~ livesearch ) | 
         ( description =~ livesearch )  
         
       }
        
     end
     
     @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
     @total = query.count
     
     
  end
      
end
