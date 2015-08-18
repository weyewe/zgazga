/*
	Control the reportProcessList.
	
	For the personal reporting, we want to extract script from the server and execute it. 
*/
Ext.define("AM.controller.ReportTreeNavigation", {
	extend : "Ext.app.Controller",
	views : [
		"report.ReportProcessList"
	],

	 
	
	refs: [
		{
			ref: 'reportProcessList',
			selector: 'reportProcessList'
		} ,
		{
			ref : 'worksheetPanel',
			selector : '#reportWorksheetPanel'
		}
	],
	 
	init : function( application ) {
		var me = this; 
		
		 
		me.control({
			"reportProcessList" : {
				'select' : this.onTreeRecordSelected
			} 
			
		});
		
	},
	
	onTreeRecordSelected : function( me, record, item, index, e ){
	    console.log("onTreeRecordSelected");
		if (!record.isLeaf()) {
			return;
		}

		this.setActiveExample( record.get('viewClass'), record.get('text'));
	},
	
	setActiveExample: function(className, title) {
      var worksheetPanel = this.getWorksheetPanel();
      
      worksheetPanel.setTitle(title);

      worksheet = Ext.create(className);
      worksheetPanel.removeAll();

      worksheetPanel.add(worksheet);
  }
});