Ext.define('AM.model.MenuDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
    	    { name: 'id', type: 'int' },
    	    { name: 'user_id', type: 'int' } , 
    	    { name: 'name', type: 'string' },
    	    
    	    { name: 'index', type: 'boolean' }, 
    	    { name: 'create', type: 'boolean' }, 
    	    { name: 'update', type: 'boolean' }, 
    	    { name: 'confirm', type: 'boolean' }, 
    	    { name: 'unconfirm', type: 'boolean' }, 
    	    { name: 'destroy', type: 'boolean' }, 
 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/menu_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'menu_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { menu_detail : record.data };
				}
			}
		}
	
  
});
