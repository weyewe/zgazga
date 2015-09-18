Ext.define('AM.view.operation.StockItem', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.stockitemProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'stockitemlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'stockitemdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});