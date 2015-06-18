class SalesOrdersController < ApplicationController 
    
    def show
        @object = SalesOrder.find_by_id params[:id]
        
        respond_to do |format|
            format.html
            format.pdf do
                render :pdf => "my_pdf", # pdf will download as my_pdf.pdf
                :layout => 'pdf', # uses views/layouts/pdf.haml
                :show_as_html => params[:debug].present? # renders html version if you set debug=true in URL
            end
        end
    end
end