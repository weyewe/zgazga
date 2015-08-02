Ext.define('AM.view.operation.Ledger', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.ledgerProcess',
	 
		
		items : [
			{
				xtype : 'ledgerlist' ,
				flex : 1 
			} 
		]
});