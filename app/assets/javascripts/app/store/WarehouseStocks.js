Ext.define('AM.store.WarehouseStocks', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.WarehouseStock'],
  	model: 'AM.model.WarehouseStock',
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
