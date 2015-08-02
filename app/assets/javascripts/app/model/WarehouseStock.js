Ext.define('AM.model.WarehouseStock', {
  	extend: 'Ext.data.Model',
  	fields: [

    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
		{ name: 'code', type: 'string' },
		{ name: 'description', type: 'string' },
			

			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/warehouse_stocks',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouse_stocks',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse_stock : record.data };
				}
			}
		}
	
  
});
