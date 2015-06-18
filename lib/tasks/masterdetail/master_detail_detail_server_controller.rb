class Api::TemplateDetailsController < Api::BaseApiController
  
  def index
    @parent = Template.find_by_id params[:template_id]
    @objects = @parent.active_template_details.joins(:template, :account).page(params[:page]).per(params[:limit]).order("id DESC")
    @total = @parent.active_template_details.count
  end

  def create
   
    @parent = Template.find_by_id params[:template_id]
    
  
    @object = TemplateDetail.create_object(params[:template_detail])
    
    
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :template_details => [@object] , 
                        :total => @parent.active_template_details.count }  
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
    @object = TemplateDetail.find_by_id params[:id] 
    @parent = @object.template 
    
    
    params[:template_detail][:template_id] = @parent.id  
    
    @object.update_object( params[:template_detail])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :template_details => [@object],
                        :total => @parent.active_template_details.count  } 
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
    @object = TemplateDetail.find(params[:id])
    @parent = @object.template 
    @object.delete_object 

    if  not @object.persisted? 
      render :json => { :success => true, :total => @parent.active_template_details.count }  
    else
      render :json => { :success => false, :total =>@parent.active_template_details.count ,
            :message => {
              :errors => extjs_error_format( @object.errors )  
            }
            }  
    end
  end
 
  
 
end
