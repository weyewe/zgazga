Ext.define('AM.model.CustomerStockAdjustment', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
			{ name: 'adjustment_date', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			{ name: 'total', type: 'string' },
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/customer_stock_adjustments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'customer_stock_adjustments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { customer_stock_adjustment : record.data };
				}
			}
		}
	
  
});
