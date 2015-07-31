Ext.define('AM.store.Ledgers', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Ledger'],
  	model: 'AM.model.Ledger',
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
