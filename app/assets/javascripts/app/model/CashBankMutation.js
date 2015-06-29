Ext.define('AM.model.CashBankMutation', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'branch_id', type: 'int' },
    	{ name: 'branch_code', type: 'string' },
    	{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } , 
			{ name: 'code', type: 'string' }     ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/cash_bank_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'cash_bank_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { cash_bank_mutation : record.data };
				}
			}
		}
	
  
});
