Ext.define('AM.view.operation.SalesQuotation', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesquotationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesquotationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesquotationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});