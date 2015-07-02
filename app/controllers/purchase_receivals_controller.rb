class PurchaseReceivalsController < ApplicationController 
  
 
  def show
    @object = PurchaseReceival.find(params[:id])
    @contact = @object.purchase_order.contact
    
    @document_title = "Bukti Penerimaan Barang"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "purchase_receival_#{@object.nomor_surat}",
        :template => 'purchase_receivals/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end