Ext.define('AM.model.ReceivableDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'amount_paid', type: 'string' },
			{ name: 'receipt_voucher_no_bukti', type: 'string' } ,
			{ name: 'rate', type: 'string' } ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/receivable_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'receivable_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { receivable_detail : record.data };
				}
			}
		}
	
  
});
