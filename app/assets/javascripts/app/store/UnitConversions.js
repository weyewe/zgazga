Ext.define('AM.store.UnitConversions', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.UnitConversion'],
  	model: 'AM.model.UnitConversion',
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
