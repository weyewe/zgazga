Ext.define('AM.view.operation.payabledetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.payabledetaillist',

  	store: 'PayableDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			// { header: 'Payable Code',  dataIndex: 'payable_source_code', flex: 1},
			// { header: 'Currency',  dataIndex: 'payable_exchange_name', flex: 1},
			// { header: 'Amount Paid',  dataIndex: 'amount_paid', flex: 1},
			// { header: 'Rate Invoice to CashBank',  dataIndex: 'rate', flex: 1},
			// { header: 'Actual Amount',  dataIndex: 'amount', flex: 1},
			// { header: 'PPh 23',  dataIndex: 'pph_23', flex: 1},
			// { header: 'PPh 21',  dataIndex: 'pph_21', flex: 1},
			
			{
				xtype : 'templatecolumn',
				text : "Pembayaran",
				flex : 3,
				tpl : 'No Bukti PV: <br /><b>{payment_voucher_no_bukti}</b>' + '<br />' + '<br />' +
						'Jumlah Dibayar: <br /><b>{amount_paid}</b>' + '<br />' + '<br />' +
							'Rate forex:<br />  <b>{rate}</b>'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Jumlah",
				flex : 3,
				tpl : 'Pengurangan Hutang: <br /><b>{amount}</b>'    
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
		this.setTitle("Payable: " + record.get("code"));
	}
});
