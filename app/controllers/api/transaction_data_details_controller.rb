class Api::TransactionDataDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "transaction_datas"
  end
  
  
  def index
    @parent = TransactionData.find_by_id params[:transaction_data_id]
    query = @parent.active_children.joins(:account  )
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
       query  = query.where{
         (
           ( account.name =~  livesearch ) | 
           ( description =~  livesearch )  
         )         
       } 
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

 
end
