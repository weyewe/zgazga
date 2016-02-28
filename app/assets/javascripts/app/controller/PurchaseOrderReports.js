Ext.define('AM.controller.PurchaseOrderReports', {
  extend: 'Ext.app.Controller',

  stores: ['PurchaseOrders'],
  models: ['PurchaseOrder'],

  views: [
    'report.purchaseorderreport.Form' 
  ],

  	refs: [
		{
			ref : 'form',
			selector : 'purchaseorderreportform'
		}
	],

  init: function() {
    this.control({
    //   'kartubukubesarlist': {
    //     itemdblclick: this.editObject,
    //     selectionchange: this.selectionChange,
				// afterrender : this.loadObjectList,
    //   },
      'purchaseorderreportform button[action=printObject]': {
        click: this.printObject
      },
    });
  },
	
	 printObject: function(){
	 	 //var view = Ext.widget('kartubukubesarform');
	 	 
	 	 var form = this.getForm();
	 	 var start_date = form.getForm().findField('start_date').getValue();
	 	 var end_date = form.getForm().findField('end_date').getValue();
	 	 var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		 var auth_token_value = currentUser['auth_token'];
			// if( start_date & end_date & account_id ){
				window.open( 'purchase_orders_' + 'download_report' 
				+ "?auth_token=" +auth_token_value
				+ ";start_date=" + start_date 
				+ ";end_date=" + end_date 
				);
			// }
			
	},
	


});