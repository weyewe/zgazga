class Api::BlanketsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = Blanket.joins(:uom,:machine,:contact).where{
          (
            ( sku =~  livesearch )  | 
            ( name =~  livesearch )  | 
            ( amount =~ livesearch ) | 
            ( uom.name =~ livesearch ) | 
            ( ac =~ livesearch ) | 
            ( ar =~ livesearch ) | 
            ( thickness =~ livesearch ) | 
            ( machine.name =~ livesearch ) | 
            ( adhesive.name =~ livesearch ) | 
            ( adhesive2.name =~ livesearch ) | 
            ( roll_blanket_item.name =~ livesearch ) | 
            ( right_bar_item.name =~ livesearch ) | 
            ( left_bar_item.name =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( application_case =~ livesearch ) | 
            ( cropping_type =~ livesearch ) | 
            ( left_over_ac =~ livesearch ) | 
            ( left_over_ar =~ livesearch ) 
          )

        }.page(params[:page]).per(params[:limit])

        @total = Blanket.joins(:uom,:machine,:contact).where{
          (
            ( sku =~  livesearch )  | 
            ( name =~  livesearch )  | 
            ( amount =~ livesearch ) | 
            ( uom.name =~ livesearch ) | 
            ( ac =~ livesearch ) | 
            ( ar =~ livesearch ) | 
            ( thickness =~ livesearch ) | 
            ( machine.name =~ livesearch ) | 
            ( adhesive.name =~ livesearch ) | 
            ( adhesive2.name =~ livesearch ) | 
            ( roll_blanket_item.name =~ livesearch ) | 
            ( right_bar_item.name =~ livesearch ) | 
            ( left_bar_item.name =~ livesearch ) | 
            ( contact.name =~ livesearch ) | 
            ( application_case =~ livesearch ) | 
            ( cropping_type =~ livesearch ) | 
            ( left_over_ac =~ livesearch ) | 
            ( left_over_ar =~ livesearch ) 
          )
        }.count
   
    else
      puts "In this shite"
      @objects = Blanket.page(params[:page]).per(params[:limit])
      @total = Blanket.count 
    end
    
    
    # render :json => { :blankets => @objects , :total => @total , :success => true }
  end

  def create
    @object = Blanket.create_object( params[:blanket] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :blankets => [@object] , 
                        :total => Blanket.active_objects.count  }  
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
    @object = Blanket.find(params[:id]) 
    

    @object.update_object( params[:blanket] )
    
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :blankets => [@object],
                        :total => Blanket.active_objects.count } 
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
  
  def show
    @object = Blanket.find_by_id params[:id]
    render :json => { :success => true, 
                      :blankets => [@object] , 
                      :total => Blanket.count }
  end

  def destroy
    @object = Blanket.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => Blanket.active_objects.count }  
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
  
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Blanket.joins(:uom,:machine,:contact).where{ 
            ( sku =~  query )  | 
            ( name =~  query )  | 
            ( amount =~ query ) | 
            ( uom.name =~ query ) | 
            ( ac =~ query ) | 
            ( ar =~ query ) | 
            ( thickness =~ query ) | 
            ( machine.name =~ query ) | 
            ( adhesive.name =~ query ) | 
            ( adhesive2.name =~ query ) | 
            ( roll_blanket_item.name =~ query ) | 
            ( right_bar_item.name =~ query ) | 
            ( left_bar_item.name =~ query ) | 
            ( contact.name =~ query ) | 
            ( application_case =~ query ) | 
            ( cropping_type =~ query ) | 
            ( left_over_ac =~ query ) | 
            ( left_over_ar =~ query ) 
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Blanket.joins(:uom,:machine,:contact).where{ 
         ( sku =~  query )  | 
            ( name =~  query )  | 
            ( amount =~ query ) | 
            ( uom.name =~ query ) | 
            ( ac =~ query ) | 
            ( ar =~ query ) | 
            ( thickness =~ query ) | 
            ( machine.name =~ query ) | 
            ( adhesive.name =~ query ) | 
            ( adhesive2.name =~ query ) | 
            ( roll_blanket_item.name =~ query ) | 
            ( right_bar_item.name =~ query ) | 
            ( left_bar_item.name =~ query ) | 
            ( contact.name =~ query ) | 
            ( application_case =~ query ) | 
            ( cropping_type =~ query ) | 
            ( left_over_ac =~ query ) | 
            ( left_over_ar =~ query ) 
        
                              }.count
    else
      @objects = Blanket.joins(:uom,:machine,:contact).where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Blanket.joins(:uom,:machine,:contact).where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
