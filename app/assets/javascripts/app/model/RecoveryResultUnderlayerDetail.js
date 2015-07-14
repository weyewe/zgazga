Ext.define('AM.model.RecoveryResultUnderlayerDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	    { name: 'id', type: 'int' },
    	    { name: 'recovery_order_detail_id', type: 'int' },
    	    { name: 'finish_amount', type: 'string' },
    	    { name: 'defect_amount', type: 'string' },
    	    { name: 'reject_amount', type: 'string' },
			{ name: 'batch_instance_id', type: 'int' } ,
			{ name: 'batch_instance_name', type: 'string' } ,
		 
		 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_result_underlayer_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_result_underlayer_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_result_underlayer_detail : record.data };
				}
			}
		}
	
  
});
