Ext.define('AM.view.operation.rolleridentificationform.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.rolleridentificationformlist',

  	store: 'RollerIdentificationForms',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
			// {	header: 'No.Diss', dataIndex: 'nomor_disasembly', flex: 2 },
			
			// {	header: 'Warehouse', dataIndex: 'warehouse_name', flex: 2 },
			// {	header: 'InHouse', dataIndex: 'is_in_house', flex: 2 },
			// {	header: 'Contact', dataIndex: 'contact_name', flex: 2 },
			// {	header: 'QTY', dataIndex: 'amount', flex: 2 },
			// {	header: 'Identified Date', dataIndex: 'identified_date', flex: 2 },
			// {	header: 'Incoming Roll Date', dataIndex: 'incoming_roll', flex: 2 },
			
			{
				xtype : 'templatecolumn',
				text : "Deskripsi",
				flex : 3,
				tpl : 	'No. Diss: <br /> <b>{nomor_disasembly}</b>'  + '<br />' + '<br />' +
							'Gudang: <br /> <b>{warehouse_name}</b>' 
			},
			
			{
				xtype : 'templatecolumn',
				text : "Order",
				flex : 3,
				tpl : 	'In-House: <br /> <b>{is_in_house}</b>'  + '<br />' + '<br />' +
							'Customer: <br /> <b>{contact_name}</b>'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Identifikasi",
				flex : 3,
				tpl : 	'Quantity: <br /> <b>{amount}</b>'  + '<br />' + '<br />' +
							'Incoming Roll Date: <br /> <b>{incoming_roll}</b>'  + '<br />' + '<br />' +
							'Identified Date: <br /> <b>{identified_date}</b>' 
			},
			
			
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 	'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <br /> <b>{confirmed_at}</b>' 
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
					this.confirmObjectButton, this.unconfirmObjectButton,
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
