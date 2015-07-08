class Api::RollerAccDetailsController < Api::BaseApiController
  
  def index
    @parent = RollerAcc.find_by_id params[:roller_acc_id]
    @objects = @parent.active_children.joins(:roller_acc, :item => [:uom]).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_children.count
  end

  def create
   
    @parent = RollerAcc.find_by_id params[:roller_acc_id]
    
  
    @object = RollerAccDetail.create_object(params[:roller_acc_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :roller_acc_details => [@object] , 
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
    @object = RollerAccDetail.find_by_id params[:id] 
    @parent = @object.roller_acc 
    
    
    params[:roller_acc_detail][:roller_acc_id] = @parent.id  
    
    @object.update_object( params[:roller_acc_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :roller_acc_details => [@object],
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
    @object = RollerAccDetail.find(params[:id])
    @parent = @object.roller_acc 
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
      @objects = RollerAccDetail.joins(:roller_acc, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  | 
        ( code  =~ query  )  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
                        
      @total = RollerAccDetail.joins(:roller_acc, :item => [:uom]).where{ 
        ( item.sku  =~ query ) | 
        ( item.name =~ query ) | 
        ( item.description  =~ query  )  |
        ( code  =~ query  )  
      }.count
    else
      @objects = RollerAccDetail.where{ 
              (id.eq selected_id)  
      }.
      page(params[:page]).
      per(params[:limit]).
      order("id DESC")
   
      @total = RollerAccDetail.where{ 
              (id.eq selected_id)   
      }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
 
  
 
end
