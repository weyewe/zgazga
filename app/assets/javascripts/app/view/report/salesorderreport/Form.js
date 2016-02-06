Ext.define('AM.view.report.salesorderreport.Form', {
  extend: 'Ext.form.Panel',
  alias : 'widget.salesorderreportform',

  //title : 'Add / Edit KartuBukuBesar',
  //layout: 'fit',
	// bodyPadding: 5,
    width: 350,
  //autoShow: true,  // does it need to be called?
	// modal : false, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 4,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '30%'
      },
      items: [
				{
					xtype: 'datefield',
					name : 'start_date',
					fieldLabel: 'From Date',
					submitFormat: 'Y-m-d',
					format: 'Y-m-d',
				},
				{
					xtype: 'datefield',
					name : 'end_date',
					fieldLabel: 'End Date',
					submitFormat: 'Y-m-d',
					format: 'Y-m-d',
				},
			]
    }];
    
    
	this.printObjectButton = new Ext.Button({
			text: 'Print',
			action: 'printObject'
		});


	this.tbar = [this.printObjectButton
						
		];
    // this.buttons = [{
    //   text: 'Save',
    //   action: 'save'
    // }, {
    //   text: 'Cancel',
    //   scope: this,
    //   handler: this.close
    // }];

    this.callParent(arguments);
  },

	setComboBoxData : function( record){
		// console.log("Inside the Form.. edit.. setComboBox data");
		// var role_id = record.get("role_id");
		// var comboBox = this.down('form').getForm().findField('role_id'); 
		// var me = this; 
		// var store = comboBox.store; 
		// store.load({
		// 	params: {
		// 		selected_id : role_id 
		// 	},
		// 	callback : function(records, options, success){
		// 		me.setLoading(false);
		// 		comboBox.setValue( role_id );
		// 	}
		// });
	}
});

