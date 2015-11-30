class RollerIdentificationFormsController < ApplicationController
    def show
                
        user = User.find_by_authentication_token params[:auth_token]
        if user.nil?
          redirect_to root_url 
          return
        end
        
        @object = RollerIdentificationForm.find(params[:id])
        @contact = @object.contact
        
        @document_title = "RollerIdentificationForm"
        respond_to do |format|
          format.html
          
          format.pdf do
            render :pdf => "roller_identification_form_#{@object.code}",
            :template => 'roller_identification_forms/show.pdf.erb',
            :layout => 'pdf.html.erb',
            :orientation => 'Landscape', 
            # :layout => 'balance_sheet_pdf.html.erb',
            :show_as_html => params[:debug].present?
          end
        end
    end
end