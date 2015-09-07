Ext.define('AM.model.PurchaseRequestDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'purchase_request_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'name', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'category', type: 'int' },
    	    { name: 'category_text', type: 'string' },
    	    { name: 'uom', type: 'string' },
			{ name: 'code', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_request_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_request_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_request_detail : record.data };
				}
			}
		}
	
  
});
