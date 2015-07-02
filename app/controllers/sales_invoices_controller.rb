class SalesInvoicesController < ApplicationController 
  
 
  def show
    @object = SalesInvoice.find(params[:id])
    
    @document_title = "Invoice"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "sales_invoice_#{@object.nomor_surat}",
        :template => 'sales_invoices/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end