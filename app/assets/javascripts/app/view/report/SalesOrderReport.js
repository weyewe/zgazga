Ext.define('AM.view.report.SalesOrderReport', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesorderreportProcess',
	 
		
		items : [
			{
				xtype : 'salesorderreportform' ,
				flex : 1 
			} 
		]
});