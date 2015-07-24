class Api::PayableDetailsController < Api::BaseApiController
  
  def index
    @parent = Payable.find_by_id params[:payable_id]
    
    parent_id = @parent.id 
    
    query =  PaymentVoucherDetail.joins(:payment_voucher, :payable).where{
      (payable_id.eq   parent_id) & 
      ( payment_voucher.is_confirmed.eq true )
    }
    
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end
 
  
 
end
