Ext.define('AM.model.StockItem', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	{ name: 'name', type: 'string' },
    	{ name: 'sku', type: 'string' },
    	{ name: 'description', type: 'string' },
    	{ name: 'amount', type: 'string' },
    	{ name: 'customer_amount', type: 'string' },
    	{ name: 'pending_delivery', type: 'string' },
    	{ name: 'pending_receival', type: 'string' },
    	{ name: 'is_tradeable', type: 'boolean' },
    	{ name: 'virtual', type: 'string' },
    	
    	{ name: 'minimum_amount', type: 'string' },
    	{ name: 'selling_price', type: 'string' },
    	{ name: 'price_list', type: 'string' },
    	
 
		{ name: 'item_type_id', type: 'int' },
		{ name: 'item_type_name', type: 'string' },
		{ name: 'sub_type_id', type: 'int' },
		{ name: 'sub_type_name', type: 'string' },
		{ name: 'exchange_id', type: 'int' },
		{ name: 'exchange_name', type: 'string' },
		{ name: 'uom_id', type: 'int' },
		{ name: 'uom_name', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/stock_items',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'stock_items',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { stock_item : record.data };
				}
			}
		}
	
  
});
