class Api::KartuBukuBesarsController < Api::BaseApiController
  
  def index
     
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
        
        
        @objects = KartuBukuBesar.where{
          (
            ( name =~  livesearch )  | 
            ( address =~ livesearch ) | 
            ( description =~ livesearch ) | 
            ( contact_no =~ livesearch ) | 
            ( email =~ livesearch )
          )

        }.page(params[:page]).per(params[:limit]).order("id DESC")

        @total = KartuBukuBesar.where{
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
      @objects = KartuBukuBesar.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = KartuBukuBesar.count 
    end
    
    
    # render :json => { :kartu_buku_besars => @objects , :total => @total , :success => true }
  end

  def create
    @object = KartuBukuBesar.create_object( params[:kartu_buku_besar] )
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :kartu_buku_besars => [@object] , 
                        :total => KartuBukuBesar.active_objects.count  }  
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
    @object = KartuBukuBesar.find(params[:id]) 
    

    @object.update_object( params[:kartu_buku_besar] )
    
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :kartu_buku_besars => [@object],
                        :total => KartuBukuBesar.active_objects.count } 
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
    @object = KartuBukuBesar.find_by_id params[:id]
    render :json => { :success => true, 
                      :kartu_buku_besars => [@object] , 
                      :total => KartuBukuBesar.count }
  end

  def destroy
    @object = KartuBukuBesar.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do 
        @object.delete_object 
      end
    rescue ActiveRecord::ActiveRecordError  
    else
    end
    
    

    if not @object.persisted?  
      render :json => { :success => true, :total => KartuBukuBesar.active_objects.count }  
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
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = KartuBukuBesar.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = KartuBukuBesar.where{ 
          ( name =~  livesearch )  | 
          ( address =~ livesearch ) | 
          ( description =~ livesearch ) | 
          ( contact_no =~ livesearch ) | 
          ( email =~ livesearch )
        
                              }.count
    else
      @objects = KartuBukuBesar.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = KartuBukuBesar.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
