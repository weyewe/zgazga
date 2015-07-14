Ext.define('AM.store.RecoveryResultUnderlayerDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryResultUnderlayerDetail'],
  	model: 'AM.model.RecoveryResultUnderlayerDetail',
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
