Ext.define('AM.model.WarehouseStockDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
 
    
	        { name: 'warehouse_stock_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'item_name', type: 'string' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_uom_name', type: 'string' },
			{ name: 'amount', type: 'string' } ,
			{ name: 'customer_amount', type: 'string' } ,
 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/warehouse_stock_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouse_stock_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse_stock_detail : record.data };
				}
			}
		}
	
  
});
