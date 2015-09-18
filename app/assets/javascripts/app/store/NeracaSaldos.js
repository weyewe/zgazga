Ext.define('AM.store.NeracaSaldos', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.NeracaSaldo'],
  	model: 'AM.model.NeracaSaldo',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
