Ext.define('AM.store.MenuDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.MenuDetail'],
  	model: 'AM.model.MenuDetail',
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
