Ext.define('AM.view.master.Menu', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.menuProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'menulist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'menudetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});