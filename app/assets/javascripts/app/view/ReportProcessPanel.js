Ext.define('AM.view.ReportProcessPanel', {
    extend: 'Ext.panel.Panel',
		alias : 'widget.reportProcessPanel',
    

		layout: {
        type : 'hbox',
        align: 'stretch'
    },
    
    items: [
			{
				bodyPadding: 5,
				xtype: 'reportProcessList',
				flex : 1
			}, 
      {
			flex :  6, 
  			id   : 'reportWorksheetPanel', 
		     bodyPadding: 0,
			layout : {
				type: 'fit'
			},
			items : [
				{
					xtype: 'reportDefault'
					 // : "Ini adalah tampilan report. Anda dapat membuat report baru, atau menambah customer",
				}
			]
      }
    ]
 
});
