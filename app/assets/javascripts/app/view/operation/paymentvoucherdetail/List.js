Ext.define('AM.view.operation.paymentvoucherdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.paymentvoucherdetaillist',

  	store: 'PaymentVoucherDetails', 
 

	initComponent: function() {
		this.columns = [
		 	
			{ header: 'Payable Code',  dataIndex: 'payable_source_code', flex: 1},
			{ header: 'Currency',  dataIndex: 'payable_exchange_name', flex: 1},
			{
				xtype : 'templatecolumn',
				text : "Amount",
				flex : 3,
				tpl :  	'Amount Paid: <br /> <b>{amount_paid}</b>' + '<br />' + '<br />' +
							'Rate to CashBank:  <br /> <b>{rate}</b>'   + '<br />' + '<br />' +
							'Actual Amount:  <br /> <b>{amount}</b'   
			},
			{
				xtype : 'templatecolumn',
				text : "Tax",
				flex : 3,
				tpl :  	'PPh 23: <br /> <b>{pph_23}</b>' + '<br />' + '<br />' +
							'PPh 21:  <br /> <b>{pph_21}</b>'
			},
			 
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

		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		this.tbar = [this.addObjectButton,  this.editObjectButton, this.deleteObjectButton , '->', 
					this.searchField]; 
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
		this.setTitle("PaymentVoucher: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
