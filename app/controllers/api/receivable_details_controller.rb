class Api::ReceivableDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "receivables"
  end
  
  def index
    @parent = Receivable.find_by_id params[:receivable_id]
    
    parent_id = @parent.id 
    
    query =  ReceiptVoucherDetail.joins(:receipt_voucher, :receivable).where{
      ( receivable_id.eq   parent_id) & 
      ( receipt_voucher.is_confirmed.eq true )
    }
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

 
end
