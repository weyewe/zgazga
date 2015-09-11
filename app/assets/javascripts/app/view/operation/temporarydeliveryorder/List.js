Ext.define('AM.view.operation.temporarydeliveryorder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.temporarydeliveryorderlist',

  	store: 'TemporaryDeliveryOrders',  
 

	initComponent: function() {
		this.columns = [
			
			
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
			// { header: 'Nomor Surat', dataIndex: 'nomor_surat', flex: 2 },
			
			{
				xtype : 'templatecolumn',
				text : "Deskripsi",
				flex : 3,
				tpl : 	'No Surat: <br />  <b>{nomor_surat}</b>'  + '<br />' + '<br />' +
							'Code DO: <br /> <b>{delivery_order_code}</b>'  + '<br />' + '<br />' +
							'No Surat DO: <br /> <b>{delivery_order_nomor_surat}</b>'  + '<br />' + '<br />' +
							'Tujuan: <br /><b>{contact_name}</b>'
			},
			
			{
				xtype : 'templatecolumn',
				text : "Pengiriman",
				flex : 3,
				tpl : 	'Customer: <br />  <b>{contact_name}</b>'  + '<br />' + '<br />' +
							'Gudang: <br /> <b>{warehouse_name}</b>'  + '<br />' + '<br />' +
							'Tanggal Delivery: <br /><b>{delivery_date}</b>'
			},
			
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 	'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <br /> <b>{confirmed_at}</b>' 
			},
			
			
			// { header: 'ID', dataIndex: 'id'},
			// { header: 'Kode',  dataIndex: 'code', flex: 1},
			// {	header: 'Nomor Surat', dataIndex: 'nomor_surat', flex: 2 },
			// {	header: 'Contact', dataIndex: 'contact_name', flex: 2 },
			// {	header: 'Nomor Surat DeliveryOrder', dataIndex: 'delivery_order_nomor_surat', flex: 2 },
			// {	header: 'Warehouse', dataIndex: 'warehouse_name', flex: 2 },
			// {	header: 'Tanggal Delivery', dataIndex: 'delivery_date', flex: 2 },
		 //	{
			// 	xtype : 'templatecolumn',
			// 	text : "Konfirmasi",
			// 	flex : 3,
			// 	tpl : 	'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
			// 				'Tanggal Konfirmasi: <b>{confirmed_at}</b>' 
			// },
			
			
 
			
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
		
		 
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,
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
