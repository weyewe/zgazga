Ext.define('AM.view.report.kartubukubesar.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.kartubukubesarlist',

  	store: 'KartuBukuBesars', 
 

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
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [
				{
					xtype: 'datefield',
					name : 'start_date',
					fieldLabel: 'From Date',
					format: 'Y-m-d',
				},
				{
					xtype: 'datefield',
					name : 'end_date',
					fieldLabel: 'End Date',
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
			text: 'Print',
			action: 'printObject'
		});


		this.tbar = [this.printObjectButton
						
		];

		// this.callParent(arguments);
	},
 
	loadMask	: true,
	
	// getSelectedObject: function() {
	// 	return this.getSelectionModel().getSelection()[0];
	// },

	// enableRecordButtons: function() {
	// 	this.editObjectButton.enable();
	// 	this.deleteObjectButton.enable();
		
		
	// 	this.markAsRunAwayObjectButton.enable();

	// 	this.unmarkAsDeceasedObjectButton.enable();
	// 	this.markAsDeceasedObjectButton.enable();



	// 	selectedObject = this.getSelectedObject();

	// 	if( selectedObject && selectedObject.get("is_deceased") == true ){
	// 		this.unmarkAsDeceasedObjectButton.show();
	// 		this.markAsDeceasedObjectButton.hide();
	// 	}else{
	// 		this.unmarkAsDeceasedObjectButton.hide();
	// 		this.markAsDeceasedObjectButton.show();
	// 	}


	// },

	// disableRecordButtons: function() {
	// 	this.editObjectButton.disable();
	// 	this.deleteObjectButton.disable();
	// 	this.markAsDeceasedObjectButton.disable();
	// 	this.unmarkAsDeceasedObjectButton.disable();
	// 	this.markAsRunAwayObjectButton.disable();

	// 	selectedObject = this.getSelectedObject();

	// 	if( selectedObject && selectedObject.get("is_deceased") == true ){
	// 		this.unmarkAsDeceasedObjectButton.show();
	// 		this.markAsDeceasedObjectButton.hide();
	// 	}else{
	// 		this.unmarkAsDeceasedObjectButton.hide();
	// 		this.markAsDeceasedObjectButton.show();
	// 	}
	// }
});
