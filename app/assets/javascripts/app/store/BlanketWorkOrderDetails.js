Ext.define('AM.store.BlanketWorkOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketWorkOrderDetail'],
  	model: 'AM.model.BlanketWorkOrderDetail',
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
