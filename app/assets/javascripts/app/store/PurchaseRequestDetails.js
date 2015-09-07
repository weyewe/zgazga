Ext.define('AM.store.PurchaseRequestDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseRequestDetail'],
  	model: 'AM.model.PurchaseRequestDetail',
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
