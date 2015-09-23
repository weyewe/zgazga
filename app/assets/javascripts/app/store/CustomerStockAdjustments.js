Ext.define('AM.store.CustomerStockAdjustments', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.CustomerStockAdjustment'],
  	model: 'AM.model.CustomerStockAdjustment',
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
