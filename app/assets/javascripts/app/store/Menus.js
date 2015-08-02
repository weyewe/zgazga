Ext.define('AM.store.Menus', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Menu'],
  	model: 'AM.model.Menu',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 20, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
