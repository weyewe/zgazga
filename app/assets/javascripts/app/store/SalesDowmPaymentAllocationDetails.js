Ext.define('AM.store.SalesDowmPaymentAllocationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesDowmPaymentAllocationDetail'],
  	model: 'AM.model.SalesDowmPaymentAllocationDetail',
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
