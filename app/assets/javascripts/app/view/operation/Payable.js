Ext.define('AM.view.operation.Payable', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.payableProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'payablelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'payabledetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});