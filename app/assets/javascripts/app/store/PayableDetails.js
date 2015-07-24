Ext.define('AM.store.PayableDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PayableDetail'],
  	model: 'AM.model.PayableDetail',
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
