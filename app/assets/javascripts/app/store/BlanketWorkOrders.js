Ext.define('AM.store.BlanketWorkOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketWorkOrder'],
  	model: 'AM.model.BlanketWorkOrder',
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
