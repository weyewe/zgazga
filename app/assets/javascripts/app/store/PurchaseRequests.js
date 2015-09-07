Ext.define('AM.store.PurchaseRequests', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseRequest'],
  	model: 'AM.model.PurchaseRequest',
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
