Ext.define('AM.view.operation.SalesDowmPaymentAllocation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesdowmpaymentallocationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesdowmpaymentallocationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesdowmpaymentallocationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});