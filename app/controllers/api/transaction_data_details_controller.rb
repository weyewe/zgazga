class Api::TransactionDataDetailsController < Api::BaseApiController
  
  def index
    @parent = TransactionData.find_by_id params[:transaction_data_id]
    @objects = @parent.active_children.joins(:account  ).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

 
end
