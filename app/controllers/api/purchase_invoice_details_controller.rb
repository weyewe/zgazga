class Api::PurchaseInvoiceDetailsController < Api::BaseApiController
  
  def index
    @parent = PurchaseInvoice.find_by_id params[:purchase_invoice_id]
    @objects = @parent.active_children.joins(:purchase_invoice).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = PurchaseInvoice.find_by_id params[:purchase_invoice_id]
    
  
    @object = PurchaseInvoiceDetail.create_object(params[:purchase_invoice_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :purchase_invoice_details => [@object] , 
                        :total => @parent.active_children.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    @object = PurchaseInvoiceDetail.find_by_id params[:id] 
    @parent = @object.purchase_invoice 
    
    
    params[:purchase_invoice_detail][:purchase_invoice_id] = @parent.id  
    
    @object.update_object( params[:purchase_invoice_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :purchase_invoice_details => [@object],
                        :total => @parent.active_children.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = PurchaseInvoiceDetail.find(params[:id])
    @parent = @object.purchase_invoice 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_children.count }  
    else
      render :json => { :success => false, :total =>@parent.active_children.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
        }  
    end
  end
 
  
 
end
