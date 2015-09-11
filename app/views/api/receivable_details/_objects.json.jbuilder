json.receivable_details objects do |object|
	json.id 								object.id 
    
     if object.class.to_s == "ReceiptVoucherDetail"
        json.receipt_voucher_no_bukti   object.receipt_voucher.no_bukti
        json.amount 						object.amount 
        json.amount_paid 						object.amount_paid 
        json.rate 						object.rate 
        json.description 						object.description 
    elsif object.class.to_s == "PurchaseDownPaymentAllocation"
        json.receipt_voucher_no_bukti object.code
        json.amount 						object.total_amount 
        json.amount_paid 						object.total_amount 
        json.rate 						object.rate_to_idr
    elsif object.class.to_s == "SalesDownPaymentAllocationDetail"
        json.receipt_voucher_no_bukti object.sales_down_payment_allocation.code
        json.amount 						object.amount 
        json.amount_paid 						object.amount_paid 
        json.rate 						object.rate
        
    end
    
    
	
end
