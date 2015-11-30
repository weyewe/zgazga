class RecoveryResultsController < ApplicationController
    def show
                
        user = User.find_by_authentication_token params[:auth_token]
        if user.nil?
          redirect_to root_url 
          return
        end
        
        @object = RecoveryOrderDetail.find(params[:id])
        
        @document_title = "RecoveryWorkCharts"
        respond_to do |format|
          format.html
          
          format.pdf do
            render :pdf => "recovery_work_processes_#{@object.id}",
            :template => 'recovery_results/show.pdf.erb',
            :layout => 'pdf.html.erb',
            # :layout => 'balance_sheet_pdf.html.erb',
            :show_as_html => params[:debug].present?
          end
        end
    end
end