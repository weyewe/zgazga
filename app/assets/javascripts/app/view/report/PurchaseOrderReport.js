Ext.define('AM.view.report.PurchaseOrderReport', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchaseorderreportProcess',
	 
		
		items : [
			{
				xtype : 'purchaseorderreportform' ,
				flex : 1 
			} 
		]
});