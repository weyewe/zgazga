Ext.define('AM.store.UnitConversionOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.UnitConversionOrder'],
  	model: 'AM.model.UnitConversionOrder',
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
