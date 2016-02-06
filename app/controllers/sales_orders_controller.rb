class SalesOrdersController < ApplicationController 
  
 
  def show
    
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    @object = SalesOrder.find(params[:id])
    @contact = @object.contact 
    
    @document_title = "ORDER CONFIRMATION"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "sales_order_#{@object.nomor_surat}",
        :template => 'sales_orders/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
  
  def download_report
    filename = "SalesOrderDaily.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    
    end_date = params[:end_date].to_date
    start_date = params[:start_date].to_date  
    
    SalesOrderReport.create_report( filepath, start_date, end_date )
    # VendorPaymentReport.create_report( filepath, start_date, end_date )
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
end