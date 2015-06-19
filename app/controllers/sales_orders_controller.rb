class SalesOrdersController < ApplicationController 
  
  WickedPdf.config = {
 
  :exe_path => '/usr/local/bin/wkhtmltopdf'
}
    
  def show
    @object = SalesOrder.find(params[:id])
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "sales_order_#{@object.nomor_surat}",
        :template => 'sales_orders/show.pdf.erb',
        :layout => 'pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end