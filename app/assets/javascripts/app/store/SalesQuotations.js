Ext.define('AM.store.SalesQuotations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesQuotation'],
  	model: 'AM.model.SalesQuotation',
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
