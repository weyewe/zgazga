Ext.define('AM.model.StockItemDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'warehouse_stock_id', type: 'int' }, 
	        { name: 'warehouse_name', type: 'string' }, 
	        { name: 'warehouse_code', type: 'string' }, 
	        { name: 'warehouse_description', type: 'string' }, 
	 		
    	    { name: 'id', type: 'int' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_name', type: 'string' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_uom_name', type: 'string' },
			{ name: 'amount', type: 'string' } ,
			{ name: 'customer_amount', type: 'string' } ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/stock_item_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'stock_item_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { stock_item_detail : record.data };
				}
			}
		}
	
  
});
