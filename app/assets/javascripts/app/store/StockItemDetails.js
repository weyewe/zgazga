Ext.define('AM.store.StockItemDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.StockItemDetail'],
  	model: 'AM.model.StockItemDetail',
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
