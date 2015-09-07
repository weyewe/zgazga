Ext.define('AM.view.operation.salesquotation.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.salesquotationlist',

  	store: 'SalesQuotations',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
			
		 	{
				xtype : 'templatecolumn',
				text : "Description",
				flex : 3,
				tpl : 'Version No: <b>{version_no}</b>' + '<br />' + '<br />' +
							'Nomor Surat:  <b>{nomor_surat}</b>'  + '<br />' + '<br />' +
							'Tanggal Surat:  <b>{quotation_date}</b>'  + '<br />' + '<br />' +
							'Customer :  <b>{customer_name}</b>'  + '<br />' + '<br />' +
							'<b>{description}</b>' 
			},
 			{
				xtype : 'templatecolumn',
				text : "Total",
				flex : 3,
				tpl : 'Total Quote Amount: <b>{total_quote_amount}</b>' + '<br />' + '<br />' +
							'Total RRP Amount:  <b>{total_rrp_amount}</b>'  + '<br />' + '<br />' +
							'Discount:  <b>{cost_saved}</b>'  + '<br />' + '<br />' +
							'Discount (%): <b>{percentage_saved}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "Transaksi",
				flex : 3,
				tpl : 'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <b>{confirmed_at}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "Status",
				flex : 3,
				tpl : 'Approve: <b>{is_approved}</b>' + '<br />' + '<br />' +
					  'Reject:  <b>{is_rejected}</b>' 
			},
			
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
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
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
	
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
			action: 'unconfirmObject',
			disabled: true,
			hidden : true
		});
		
		this.approveObjectButton = new Ext.Button({
			text: 'Approve',
			action: 'approveObject',
			disabled: true,
			hidden : true
		});
		
		this.rejectObjectButton = new Ext.Button({
			text: 'Reject',
			action: 'rejectObject',
			disabled: true,
			hidden : true
		});
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		this.filterButton  = new Ext.Button({
			text: 'Filter',
			action: 'filterObject' 
		});
		
		 
		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,this.approveObjectButton,
					this.rejectObjectButton,
					'->',
					this.filterButton,
					this.searchField ];
	 


		
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying topics {0} - {1} of {2}',
			emptyMsg: "No topics to display" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable(); 
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show();
			this.unconfirmObjectButton.enable();
			this.rejectObjectButton.show();
			this.rejectObjectButton.enable();
			this.approveObjectButton.show();
			this.approveObjectButton.enable();
			
		}else{
			this.confirmObjectButton.enable();
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
			this.rejectObjectButton.hide();
			this.approveObjectButton.hide();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
	}
});
