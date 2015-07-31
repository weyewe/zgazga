Ext.define('AM.model.Ledger', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'account_name', type: 'string' },
    	{ name: 'entry_case_text', type: 'string' },
    	{ name: 'amount', type: 'string' },
			{ name: 'created_at', type: 'string' } , 
			{ name: 'description', type: 'string' }     ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/ledgers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'ledgers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { ledger : record.data };
				}
			}
		}
	
  
});
