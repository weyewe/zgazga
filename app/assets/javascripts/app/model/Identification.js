Ext.define('AM.model.Identification', {
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
			url: 'api/identifications',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'identifications',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { identification : record.data };
				}
			}
		}
	
  
});
