Ext.define('AM.view.operation.CustomerStockAdjustment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.customerstockadjustmentProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'customerstockadjustmentlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'customerstockadjustmentdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});