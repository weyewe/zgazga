Ext.define('AM.model.UnitConversionDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'unit_conversion_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
			{ name: 'item_name', type: 'string' } ,
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/unit_conversion_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'unit_conversion_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { unit_conversion_detail : record.data };
				}
			}
		}
	
  
});
