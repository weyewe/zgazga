Ext.define('AM.view.operation.BlanketWorkOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blanketworkorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'blanketworkorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'blanketworkorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});