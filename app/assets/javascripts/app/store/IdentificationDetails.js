Ext.define('AM.store.IdentificationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.IdentificationDetail'],
  	model: 'AM.model.IdentificationDetail',
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
