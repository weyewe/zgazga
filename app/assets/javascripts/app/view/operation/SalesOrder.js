Ext.define('AM.view.operation.SalesOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesorderdetaillist',
				// html : "This is gonna be the detail",
				flex : 1
			} 
		],
 
});