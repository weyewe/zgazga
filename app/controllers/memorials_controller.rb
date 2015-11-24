class MemorialsController < ApplicationController 
  
 
  def show
    @object = Memorial.find(params[:id])
    
    @document_title = "Memorial"
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "memorial_#{@object.no_bukti}",
        :template => 'memorials/show.pdf.erb',
        :layout => 'pdf.html.erb',
        # :layout => 'balance_sheet_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end
end