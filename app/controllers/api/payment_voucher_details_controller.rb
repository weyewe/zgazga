class Api::PaymentVoucherDetailsController < Api::BaseApiController
  
  def parent_controller_name
      "payment_vouchers"
  end
  
  def index
    @parent = PaymentVoucher.find_by_id params[:payment_voucher_id]
    query = @parent.active_children.joins(:payment_voucher,:payable)
    if params[:livesearch].present? 
       livesearch = "%#{params[:livesearch]}%"
       
      query  = query.where{
        (
          ( payable.source_code  =~ livesearch  )   
        )         
      } 
    end
    @objects = query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end

  def create
   
    @parent = PaymentVoucher.find_by_id params[:payment_voucher_id]
    
  
    @object = PaymentVoucherDetail.create_object(params[:payment_voucher_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :payment_voucher_details => [@object] , 
                        :total => @parent.active_children.count }  
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return                          
    end
  end

  def update
    @object = PaymentVoucherDetail.find_by_id params[:id] 
    @parent = @object.payment_voucher 
    
    
    params[:payment_voucher_detail][:payment_voucher_id] = @parent.id  
    
    @object.update_object( params[:payment_voucher_detail])
     
    if @object.errors.size == 0 
      @total = @parent.active_children.count
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg
      return  
    end
  end

  def destroy
    @object = PaymentVoucherDetail.find(params[:id])
    @parent = @object.payment_voucher 
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
  
    def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = PaymentVoucherDetail.joins(:payment_voucher, :payable).where{ 
        ( payable.source_code  =~ query  )   
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = PaymentVoucherDetail.joins(:payment_voucher, :payable).where{ 
       ( payable.source_code  =~ query  )  
      }.count
    else
      @objects = PaymentVoucherDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = PaymentVoucherDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
