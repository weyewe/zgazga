Ext.define('AM.model.Receivable', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'sales_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    
    	    { name: 'employee_id', type: 'int' },
    	    { name: 'employee_name', type: 'string' },
    	    
    	    { name: 'exchange_id', type: 'int' },
    	    { name: 'exchange_name', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/receivables',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'receivables',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { receivable : record.data };
				}
			}
		}
	
  
});
