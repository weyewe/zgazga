Ext.define('AM.store.SalesQuotationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesQuotationDetail'],
  	model: 'AM.model.SalesQuotationDetail',
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
