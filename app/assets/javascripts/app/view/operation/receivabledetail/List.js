Ext.define('AM.view.operation.receivabledetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.receivabledetaillist',

  	store: 'ReceivableDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{
				xtype : 'templatecolumn',
				text : "Penerimaan",
				flex : 3,
				tpl : 'No Bukti RV: <br /><b>{receipt_voucher_no_bukti}</b>' + '<br />' + '<br />' +
						'Jumlah Diterima: <br /><b>{amount_paid}</b>' + '<br />' + '<br />' +
							'Rate forex:<br />  <b>{rate}</b>'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Jumlah",
				flex : 3,
				tpl : 'Pengurangan Piutang: <br /><b>{amount}</b>'    
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


		this.tbar = []; 
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
		this.setTitle("Receivable: " + record.get("code"));
	}
});
