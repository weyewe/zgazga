Ext.define('AM.model.PaymentRequest', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
			{ name: 'contact_name', type: 'string' } ,
			{ name: 'contact_id', type: 'int' } ,
			{ name: 'exchange_id', type: 'int' } ,
			{ name: 'exchange_name', type: 'string' } ,
			{ name: 'exchange_rate_amount', type: 'string' } ,
			{ name: 'account_id', type: 'int' } ,
			{ name: 'account_name', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			{ name: 'no_bukti', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			{ name: 'amount', type: 'string' } ,
			{ name: 'account_id', type: 'int' } ,
			{ name: 'request_date', type: 'string' } ,
			{ name: 'due_date', type: 'string' } ,
			{ name: 'confirmed_at', type: 'string' } ,
			{ name: 'is_confirmed', type: 'boolean' } ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_requests',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_requests',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_request : record.data };
				}
			}
		}
	
  
});
