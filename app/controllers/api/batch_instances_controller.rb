class Api::BatchInstancesController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = BatchInstance.where{
          (
            ( name =~  livesearch )  | 
            ( address =~ livesearch ) | 
            ( description =~ livesearch ) | 
            ( contact_no =~ livesearch ) | 
            ( email =~ livesearch )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = BatchInstance.where{
          (
            ( name =~  livesearch )  | 
            ( address =~ livesearch ) | 
            ( description =~ livesearch ) | 
            ( contact_no =~ livesearch ) | 
            ( email =~ livesearch )
          )
        }.count
   
    else
      puts "In this shite"
      @objects = BatchInstance.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = BatchInstance.count 
    end
    
    
    # render :json => { :batch_instances => @objects , :total => @total , :success => true }
  end

  def create
    @object = BatchInstance.create_object( params[:batch_instance] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :batch_instances => [@object] , 
                        :total => BatchInstance.active_objects.count  }  
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
    @object = BatchInstance.find(params[:id]) 
    

    @object.update_object( params[:batch_instance] )
    
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :batch_instances => [@object],
                        :total => BatchInstance.active_objects.count } 
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
  
  def show
    @object = BatchInstance.find_by_id params[:id]
    render :json => { :success => true, 
                      :batch_instances => [@object] , 
                      :total => BatchInstance.count }
  end

  def destroy
    @object = BatchInstance.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => BatchInstance.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query_value = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      query = BatchInstance.where{
          ( name =~ query_value ) | 
          ( description =~ query_value )  
      }
      
      
      
      if params[:blanket_order_detail_id].present?
        zero_value = BigDecimal("0")
        
        object  = BlanketOrderDetail.find_by_id params[:blanket_order_detail_id]
        if not object.nil?
          puts "===================>>\n\n"*5
          puts "the item_id (roll_blanket) is #{object.blanket.roll_blanket_item_id}"
          query = query.where{
            # ( amount.gt zero_value ) & 
            ( item_id.eq object.blanket.roll_blanket_item_id )
          }
        end
      end

      
      
      
      if params[:item_id].present?
        query = query.where(:item_id => params[:item_id])
      end
       
      
      
      @objects = query.page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total  = query.count 
      
    else
      @objects = BatchInstance.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = BatchInstance.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    # render :json => { :records => @objects , :total => @total, :success => true }
  end
end
