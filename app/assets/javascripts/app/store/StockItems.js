Ext.define('AM.store.StockItems', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.StockItem'],
  	model: 'AM.model.StockItem',
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
