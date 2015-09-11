class Api::PayableDetailsController < Api::BaseApiController
 
   def parent_controller_name
      "payables"
  end
  
  def index
    @parent = Payable.find_by_id params[:payable_id]
    
    parent_id = @parent.id 
    
    query =  PaymentVoucherDetail.joins(:payment_voucher, :payable).where{
      (payable_id.eq   parent_id) & 
      ( payment_voucher.is_confirmed.eq true )
    }
    
    if query.count == 0 
      query = SalesDownPaymentAllocation.joins(:payable).where{
        ( payable_id.eq parent_id ) &
        ( is_confirmed.eq true)
      }
      if query.count == 0
        query = PurchaseDownPaymentAllocationDetail.joins(:purchase_down_payment_allocation,:payable).where{
        ( payable_id.eq parent_id ) &
        ( purchase_down_payment_allocation.is_confirmed.eq true)
        }
      end
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end
 
  
 
end
