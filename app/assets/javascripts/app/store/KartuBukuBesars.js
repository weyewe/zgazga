Ext.define('AM.store.KartuBukuBesars', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.KartuBukuBesar'],
  	model: 'AM.model.KartuBukuBesar',
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
