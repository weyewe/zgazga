Ext.define('AM.model.SalesQuotationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'sales_quotation_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'rrp', type: 'string' },
			{ name: 'quotation_price', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
    	    
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_quotation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_quotation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_quotation_detail : record.data };
				}
			}
		}
	
  
});
