Ext.define('AM.model.Menu', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'name', type: 'string' } , 
			'email' 
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/menus',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'menus',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { menu : record.data };
				}
			}
		}
	
  
});
