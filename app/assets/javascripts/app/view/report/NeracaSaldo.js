Ext.define('AM.view.report.NeracaSaldo', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.neracasaldoProcess',
	 
		
		items : [
			{
				xtype : 'neracasaldolist' ,
				flex : 1 
			} 
		]
});