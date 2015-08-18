Ext.define('AM.view.report.Payable', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.payableProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'payableagingscheduleform' ,
				flex : 1  
			} ,
			{
				xtype : 'payableagingrecapform' ,
				flex : 1  
			} ,
			{
				xtype : 'payablemutationform' ,
				flex : 1  
			} ,
			{
				xtype : 'accpayableform' ,
				flex : 1  
			} ,
			{
				xtype : 'payablevendorpaymentform' ,
				flex : 1  
			} ,
			
		],
 
});