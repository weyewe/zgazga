Ext.define('AM.model.RollerBuilder', {
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
			url: 'api/roller_builders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_builders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_builder : record.data };
				}
			}
		}
	
  
});
