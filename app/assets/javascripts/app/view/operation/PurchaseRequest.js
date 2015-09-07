Ext.define('AM.view.operation.PurchaseRequest', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchaserequestProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'purchaserequestlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'purchaserequestdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});