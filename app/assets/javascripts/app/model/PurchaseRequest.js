Ext.define('AM.model.PurchaseRequest', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'request_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_requests',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_requests',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_request : record.data };
				}
			}
		}
	
  
});
