Ext.define('AM.model.TransactionDataDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
 
	
	        { name: 'transaction_data_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'account_name', type: 'string' },
    	    { name: 'account_code', type: 'string' },
			{ name: 'entry_case_text', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			
			{ name: 'is_bank_transaction', type: 'boolean' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/transaction_data_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'transaction_data_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { transaction_data_detail : record.data };
				}
			}
		}
	
  
});
