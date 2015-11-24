class ReceiptVouchersController < ApplicationController 
  
 
  def show
    @object = ReceiptVoucher.find(params[:id])
    
    @document_title = "Receipt Voucher"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "receipt_voucher_#{@object.no_bukti}",
        :template => 'receipt_vouchers/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end