class PurchaseOrdersController < ApplicationController 
  
 
  def show
    @object = PurchaseOrder.find(params[:id])
    @contact = @object.contact
    
    @document_title = "PURCHASE ORDER"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "purchase_order_#{@object.nomor_surat}",
        :template => 'purchase_orders/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end