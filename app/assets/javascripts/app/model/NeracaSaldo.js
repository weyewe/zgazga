Ext.define('AM.model.NeracaSaldo', {
  	extend: 'Ext.data.Model',
  	fields: [
    		{ name: 'id', type: 'int' },
    	    { name: 'period', type: 'int' },
			{ name: 'beginning_period', type: 'string' } ,
			{ name: 'end_date_period', type: 'string' } ,
			{ name: 'year_period', type: 'int' } ,
			{ name: 'is_year_closing', type: 'boolean' },
    	    { name: 'is_closed', type: 'boolean' },
    	    { name: 'closed_at', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/neraca_saldos',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'neraca_saldos',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { neraca_saldo : record.data };
				}
			}
		}
	
  
});
