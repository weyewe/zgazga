Ext.define('AM.controller.KartuBukuBesars', {
  extend: 'Ext.app.Controller',

  stores: ['KartuBukuBesars'],
  models: ['KartuBukuBesar'],

  views: [
    'report.kartubukubesar.List',
    'report.kartubukubesar.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'kartubukubesarlist'
		},
		{
			ref : 'form',
			selector : 'kartubukubesarform'
		},
		{
			ref : 'searchField',
			selector: 'kartubukubesarlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
    //   'kartubukubesarlist': {
    //     itemdblclick: this.editObject,
    //     selectionchange: this.selectionChange,
				// afterrender : this.loadObjectList,
    //   },
      'kartubukubesarform button[action=printObject]': {
        click: this.printObject
      },
    });
  },
	
	 printObject: function(){
	 	 //var view = Ext.widget('kartubukubesarform');
	 	 
	 	 var form = this.getForm();
	 	 var start_date = form.getForm().findField('start_date').getValue();
	 	 var end_date = form.getForm().findField('end_date').getValue();
	 	 var account_id = form.getForm().findField('account_id').getValue();
	 	 var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		 var auth_token_value = currentUser['auth_token'];
			// if( start_date & end_date & account_id ){
				window.open( 'closings_' + 'download_kartu_buku_besar' 
				+ "?auth_token=" +auth_token_value
				+ ";start_date=" + start_date 
				+ ";end_date=" + end_date 
				+ ";account_id=" + account_id 
				);
			// }
			
	},
	


});
