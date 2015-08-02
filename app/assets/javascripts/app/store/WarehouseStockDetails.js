Ext.define('AM.store.WarehouseStockDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.WarehouseStockDetail'],
  	model: 'AM.model.WarehouseStockDetail',
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
