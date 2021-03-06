Ext.define('AM.view.operation.receivable.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.receivablelist',

  	store: 'Receivables',  
 

	initComponent: function() {
		this.columns = [
			{
				xtype : 'templatecolumn',
				text : "Sumber Piutang",
				flex : 3,
				tpl : 'Dokumen: <br /><b>{source_class}</b>' + '<br />' + '<br />' +
							'Kode Dokumen:<br />  <b>{source_code}</b>'    + '<br />' + '<br />' + 
							'Customer:<br />  <b>{contact_name}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Jumlah",
				flex : 3,
				tpl : 'Total: <br /><b>{amount}</b> {exchange_name}' + '<br />' + '<br />' +
							'Sisa:  <br /><b>{remaining_amount}</b> {exchange_name}'  + '<br />' + '<br />' +
							'Oustanding clearance bank: <b>{pending_clearence_amount}</b>' 
			},
			
			
			{ header: 'Jatuh Tempo',  dataIndex: 'due_date', flex: 2},
			
			
			
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
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		 
			this.tbar = [ 
					'->',
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
		}else{
			this.confirmObjectButton.enable();
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
	}
});
