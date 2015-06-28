Ext.define('AM.model.ClosingDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'sales_order_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'pending_delivery_amount', type: 'string' },
			{ name: 'price', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
    	    
    	    { name: 'is_service', type: 'boolean' }, 
			{ name: 'is_service_text', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/closing_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'closing_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { closing_detail : record.data };
				}
			}
		}
	
  
});
