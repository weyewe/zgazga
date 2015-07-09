Ext.define('AM.view.operation.RecoveryResult', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.recoveryresultProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'recoveryresultlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'recoveryresultdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});