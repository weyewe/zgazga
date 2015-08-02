Ext.define('AM.model.PayableDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'amount_paid', type: 'string' },
			{ name: 'payment_voucher_no_bukti', type: 'string' } ,
			{ name: 'rate', type: 'string' } ,
			 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payable_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payable_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payable_detail : record.data };
				}
			}
		}
	
  
});
