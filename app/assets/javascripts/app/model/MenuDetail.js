Ext.define('AM.model.MenuDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
    	    { name: 'id', type: 'int' },
    	    
    	    { name: 'name', type: 'string' },
    	    
    	    { name: 'is_view_allowed', type: 'boolean' }, 
    	    { name: 'is_create_allowed', type: 'boolean' }, 
    	    { name: 'is_update_allowed', type: 'boolean' }, 
    	    { name: 'is_confirm_allowed', type: 'boolean' }, 
    	    { name: 'is_unconfirm_allowed', type: 'boolean' }, 
    	    { name: 'is_delete_allowed', type: 'boolean' }, 
 
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
