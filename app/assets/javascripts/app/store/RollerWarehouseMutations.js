Ext.define('AM.store.RollerWarehouseMutations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerWarehouseMutation'],
  	model: 'AM.model.RollerWarehouseMutation',
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
