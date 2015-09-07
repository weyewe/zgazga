Ext.define('AM.model.UnitConversion', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } ,
			
			{ name: 'target_item_id', type: 'int' },
    	    { name: 'target_item_name', type: 'string' },
    	    { name: 'target_item_sku', type: 'string' },
    	    { name: 'target_item_uom_name', type: 'string' },
    	    { name: 'target_amount', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/unit_conversions',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'unit_conversions',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { unit_conversion : record.data };
				}
			}
		}
	
  
});
