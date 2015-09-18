Ext.define('AM.model.WarehouseStock', {
  	extend: 'Ext.data.Model',
  	fields: [

    	   { name: 'warehouse_stock_id', type: 'int' }, 
	        { name: 'name', type: 'string' }, 
	        { name: 'code', type: 'string' }, 
	        { name: 'description', type: 'string' }, 
	 		
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
			url: 'api/warehouse_stocks',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouse_stocks',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse_stock : record.data };
				}
			}
		}
	
  
});
