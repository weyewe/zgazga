class RecoveryOrdersController < ApplicationController
    def show
                
        user = User.find_by_authentication_token params[:auth_token]
        if user.nil?
          redirect_to root_url 
          return
        end
        
        @object = RecoveryOrderDetail.find(params[:id])
        
        @document_title = "RecoveryOrder"
        respond_to do |format|
          format.html
          
          format.pdf do
            render :pdf => "recovery_orders_#{@object.code}",
            :template => 'recovery_orders/show.pdf.erb',
            :layout => 'pdf.html.erb',
            :orientation => 'Landscape', 
            # :layout => 'balance_sheet_pdf.html.erb',
            :show_as_html => params[:debug].present?
          end
        end
    end
end