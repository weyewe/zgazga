class ClosingsController < ApplicationController 
  
 
  def download_report
    filename = "NeracaReport.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    
    end_date = DateTime.now
    start_date = end_date - 1.weeks 
    
    # NeracaReport.create_report( filepath, start_date, end_date, Closing.first  )
    VendorPaymentReport.create_report( filepath, start_date, end_date )
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
  def download_labarugi
    filename = "LabaRugiBulanBerjalan.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    
    end_date = DateTime.now
    start_date = end_date - 1.weeks 
    
    ProfitLossStatement.create_report( filepath, start_date, end_date, Closing.first  )
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
  # def show
        
  #   user = User.find_by_authentication_token params[:auth_token]
  #   if user.nil?
  #     redirect_to root_url 
  #     return
  #   end
    
  #   @object = SalesInvoice.find(params[:id])
  #   @contact = @object.delivery_order.sales_order.contact 
    
  #   @document_title = "Invoice"
  #   respond_to do |format|
  #     format.html
  #     format.pdf do
  #       render :pdf => "sales_invoice_#{@object.nomor_surat}",
  #       :template => 'sales_invoices/show.pdf.erb',
  #       :layout => 'pdf.html.erb',
  #       # :layout => 'balance_sheet_pdf.html.erb',
  #       :show_as_html => params[:debug].present?
  #     end
  #   end
  # end
  
  

  
  
  
  def print_csv
        
    user = User.find_by_authentication_token params[:auth_token]
    if user.nil?
      redirect_to root_url 
      return
    end
    
    query =   SalesInvoice.active_objects.joins(:delivery_order =>[:sales_order =>[:contact,:exchange]])
    # puts "The query : #{query}"
    # puts "initial query total: #{query.count}"
    
    if params[:livesearch].present?
      
      # livesearch = params[:livesearch]
      livesearch = "%#{params[:livesearch]}%"
      query = query.where{
         (
           ( description =~  livesearch ) | 
           ( code =~ livesearch)  | 
           ( nomor_surat =~ livesearch)  | 
           ( delivery_order.code =~  livesearch) |
           ( delivery_order.nomor_surat =~  livesearch)
         )

       }
    end
    
    # puts "after livesearch query total: #{query.count}" 
    
    if params[:is_filter].present?
        
      start_confirmation =  parse_date( params[:start_confirmation] )
      end_confirmation =  parse_date( params[:end_confirmation] )
      start_invoice_date =  parse_date( params[:start_invoice_date] )
      end_invoice_date =  parse_date( params[:end_invoice_date] )
      
       
      
      if params[:is_confirmed].present?
        query = query.where(:is_confirmed => true ) 
        if  start_confirmation.present?
          query = query.where{ confirmed_at.gte start_confirmation }
        end
        
        if end_confirmation.present?
          query = query.where{ confirmed_at.lt  end_confirmation }
        end
      else
        query = query.where(:is_confirmed => false )
      end
    
      if start_invoice_date.present?
        query = query.where{ invoice_date.gte start_invoice_date}
      end
      
      if end_invoice_date.present?
        query = query.where{ invoice_date.lt end_invoice_date}
      end
      
      object = DeliveryOrder.find_by_id params[:delivery_order_id]
      if not object.nil? 
        query = query.where(:delivery_order_id => object.id )
      end
    end
    
   
    
    @objects = query.order("id DESC")
    @total = query.count 
      
    respond_to do |format|
      format.html
      format.csv { send_data @objects.to_csv , :filename => "your_file_name.csv" } 
      # format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end
end