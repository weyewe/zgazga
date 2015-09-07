Ext.define('AM.model.SalesQuotation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'quotation_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'version_no', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			{ name: 'total_quote_amount', type: 'string' } ,
			{ name: 'total_rrp_amount', type: 'string' } ,
			{ name: 'cost_saved', type: 'string' } ,
			{ name: 'percentage_saved', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    
    	    
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'is_approved', type: 'boolean' } , 
			{ name: 'is_rejected', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_quotations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_quotations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_quotation : record.data };
				}
			}
		}
	
  
});
