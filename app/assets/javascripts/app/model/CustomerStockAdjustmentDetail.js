Ext.define('AM.model.CustomerStockAdjustmentDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'customer_stock_adjustment_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
    	    { name: 'status', type: 'int' }, 
    	    { name: 'status_text', type: 'string' }, 
    	    { name: 'amount', type: 'string' }, 
    	    { name: 'price', type: 'string' }, 
    	    
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/customer_stock_adjustment_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'customer_stock_adjustment_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { customer_stock_adjustment_detail : record.data };
				}
			}
		}
	
  
});
