Ext.define('AM.store.BatchInstances', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BatchInstance'],
  	model: 'AM.model.BatchInstance',
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
