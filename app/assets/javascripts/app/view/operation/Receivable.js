Ext.define('AM.view.operation.Receivable', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.receivableProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'receivablelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'receivabledetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});