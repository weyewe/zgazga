Ext.define('AM.view.operation.transactiondatadetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.transactiondatadetaillist',

  	store: 'TransactionDataDetails', 
 

	initComponent: function() {
		this.columns = [ 
			{ header: 'Status', dataIndex: 'entry_case_text', flex: 1},
			
			{
				xtype : 'templatecolumn',
				text : "Account", 
				flex: 1, 
				tpl : '[{account_code}] {account_name}'   
			},
			
			{ header: 'Amount', dataIndex: 'amount', flex: 1},
			{ header: 'Description', dataIndex: 'description', flex: 1}, 
			 
		];
		

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject',
			disabled : true 
		});
		
	 

		this.editObjectButton = new Ext.Button({
			text: 'Edit',
			action: 'editObject',
			disabled: true
		});
		
		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});


		this.tbar = [  ]; 
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Details {0} - {1} of {2}',
			emptyMsg: "No details" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	 
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},
	
	enableAddButton: function(){
		this.addObjectButton.enable();
	},
	
	disableAddButton: function(){
		this.addObjectButton.disable();
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	},
	
	setObjectTitle : function(record){
		this.setTitle("TransactionData: " + record.get("code"));
	}
});
