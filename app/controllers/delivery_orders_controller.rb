class DeliveryOrdersController < ApplicationController 
  
 
  def show
    @object = DeliveryOrder.find(params[:id])
    
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "delivery_order_#{@object.nomor_surat}",
        :template => 'delivery_orders/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end