Ext.define('AM.store.SalesDowmPaymentAllocations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesDowmPaymentAllocation'],
  	model: 'AM.model.SalesDowmPaymentAllocation',
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
