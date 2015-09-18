Ext.define('AM.view.report.neracasaldo.Form', {
  extend: 'Ext.form.Panel',
  alias : 'widget.neracasaldoform',

  //title : 'Add / Edit KartuBukuBesar',
  //layout: 'fit',
	// bodyPadding: 5,
    width: 350,
  //autoShow: true,  // does it need to be called?
	// modal : false, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		var remoteJsonStoreAccount = Ext.create(Ext.data.JsonStore, {
		storeId : 'account_search',
		fields	: [
		 		{
					name : 'account_code',
					mapping : "code"
				}, 
				{
					name : 'account_name',
					mapping : 'name'
				},
				{
					name : 'account_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_ledger_accounts',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
		
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
				{
					fieldLabel: 'Account',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'account_name',
					valueField : 'account_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreAccount , 
					listConfig : {
						getInnerTpl: function(){
								return  	'<div data-qtip="{account_name}">' + 
		  											'<div class="combo-name">Code : {account_code}</div>' + 
		  											'<div class="combo-name">Name: {account_name}</div>' + 
		  					 					'</div>';
							}
						},
					name : 'account_id' 
				},
			]
    }];
    
    
	this.printObjectButton = new Ext.Button({
			text: 'Print Neraca',
			action: 'printObject'
		});
	



	this.tbar = [this.printObjectButton,this.printPosNeracaObjectButton
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

