Ext.define('AM.view.operation.Identification', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.identificationProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'identificationlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'identificationdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});