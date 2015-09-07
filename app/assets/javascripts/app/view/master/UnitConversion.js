Ext.define('AM.view.master.UnitConversion', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.unitconversionProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'unitconversionlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'unitconversiondetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});