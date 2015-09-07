Ext.define('AM.model.UnitConversionOrder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'code', type: 'string' }     ,
		{ name: 'description', type: 'string' }     ,
		{ name: 'unit_conversion_id', type: 'int' }     ,
		{ name: 'unit_conversion_name', type: 'string' }     ,
		{ name: 'unit_conversion_target_item_sku', type: 'string' }     ,
		{ name: 'unit_conversion_target_item_name', type: 'string' }     ,
		{ name: 'unit_conversion_target_item_uom_name', type: 'string' }     ,
		{ name: 'unit_conversion_target_amount', type: 'string' }     ,
		{ name: 'conversion_date', type: 'string' }     ,
		{ name: 'warehouse_id', type: 'int' }     ,
		{ name: 'warehouse_name', type: 'string' }     ,
		{ name: 'is_confirmed', type: 'boolean' }     ,
		{ name: 'confirmed_at', type: 'string' }     ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/unit_conversion_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'unit_conversion_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { unit_conversion_order : record.data };
				}
			}
		}
	
  
});
