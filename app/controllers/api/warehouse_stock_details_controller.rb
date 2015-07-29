class Api::WarehouseStockDetailsController < Api::BaseApiController
  
  
  def parent_controller_name
      "warehouse_stocks"
  end
  
  def index
    @parent = Warehouse.find_by_id params[:warehouse_stock_id]
    
    query  = WarehouseItem.joins( :warehouse, :item => [:uom]).where(
        :warehouse_id => @parent.id 
      ) 
    
    @objects =  query.page(params[:page]).per(params[:limit]).order("id DESC")
    @total = query.count
  end
 
  
 
end
