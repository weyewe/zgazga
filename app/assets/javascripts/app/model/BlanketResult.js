Ext.define('AM.model.BlanketResult', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'blanket_order_id', type: 'int' }, 
	        { name: 'blanket_id', type: 'int' }, 
	        { name: 'blanket_sku', type: 'string' }, 
	        { name: 'blanket_name', type: 'string' }, 
	        { name: 'blanket_order_production_no', type: 'string' }, 
	        { name: 'blanket_order_code', type: 'string' }, 
	        { name: 'blanket_roll_blanket_item_id', type: 'int' }     ,
			{ name: 'blanket_roll_blanket_item_name', type: 'string' }     ,
			{ name: 'blanket_roll_blanket_item_sku', type: 'string' }     ,
			{ name: 'blanket_left_bar_item_id', type: 'int' }     ,
			{ name: 'blanket_left_bar_item_name', type: 'string' }     ,
			{ name: 'blanket_left_bar_item_sku', type: 'string' }     ,
			{ name: 'blanket_right_bar_item_id', type: 'int' }     ,
			{ name: 'blanket_right_bar_item_name', type: 'string' }     ,
			{ name: 'blanket_right_bar_item_sku', type: 'string' }     ,
    	    { name: 'id', type: 'int' },
    	    { name: 'total_cost', type: 'string' },
    	    { name: 'is_cut', type: 'boolean' },
    	    { name: 'is_side_sealed', type: 'boolean' },
    	    { name: 'is_bar_prepared', type: 'boolean' },
    	    { name: 'is_adhesive_tape_applied', type: 'boolean' },
    	    { name: 'is_bar_mounted', type: 'boolean' },
    	    { name: 'is_bar_heat_pressed', type: 'boolean' },
    	    { name: 'is_bar_pull_off_tested', type: 'boolean' },
    	    { name: 'is_qc_and_marked', type: 'boolean' },
    	    { name: 'is_packaged', type: 'boolean' },
    	    { name: 'is_rejected', type: 'boolean' },
    	    { name: 'rejected_date', type: 'string' },
    	    { name: 'is_job_scheduled', type: 'boolean' },
    	    { name: 'is_finished', type: 'boolean' },
    	    { name: 'finished_at', type: 'string' },
    	    { name: 'bar_cost', type: 'string' },
    	    { name: 'adhesive_cost', type: 'string' },
    	    { name: 'roll_blanket_cost', type: 'string' },
    	    { name: 'roll_blanket_usage', type: 'string' },
    	    { name: 'roll_blanket_defect', type: 'string' },		
    	    { name: 'quantity', type: 'int' },	
    	    { name: 'rejected_quantity', type: 'int' },	
    	    { name: 'finished_quantity', type: 'int' },	
    	    { name: 'test_left_bar_usage', type: 'string' },
    	    { name: 'test_right_bar_usage', type: 'string' },
    	    
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blanket_results',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blanket_results',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket_result : record.data };
				}
			}
		}
	
  
});
