Ext.define('AM.view.operation.WarehouseStock', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.warehousestockProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'warehousestocklist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'warehousestockdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});