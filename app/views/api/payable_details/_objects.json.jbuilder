json.payable_details objects do |object|
	json.id 								object.id 
    json.payable_id 			 object.payable_id
    
    
    if object.class.to_s == "PaymentVoucherDetail"
        json.payment_voucher_no_bukti   object.payment_voucher.no_bukti
        json.amount 						object.amount 
        json.amount_paid 						object.amount_paid 
        json.rate 						object.rate 
        json.description 						object.description 
    elsif object.class.to_s == "SalesDownPaymentAllocation"
        json.payment_voucher_no_bukti object.code
        json.amount 						object.total_amount 
        json.amount_paid 						object.total_amount 
        json.rate 						object.rate_to_idr
    elsif object.class.to_s == "PurchaseDownPaymentAllocationDetail"
        json.receipt_voucher_no_bukti object.purchase_down_payment_allocation.code
        json.amount 						object.amount 
        json.amount_paid 						object.amount_paid 
        json.rate 						object.rate   
    end
    
    
   
	
end
