Ext.define('AM.view.master.item.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.itemlist',

  	store: 'Items', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{	header: 'Sku', dataIndex: 'sku', flex: 1 } ,
			{ header: 'Nama',  dataIndex: 'name', flex: 1},
			{ header: 'Ready',  dataIndex: 'amount', flex: 1},
			{ header: 'Pending Receival',  dataIndex: 'pending_receival', flex: 1},
			{ header: 'Pending Delivery',  dataIndex: 'pending_delivery', flex: 1},
			{ header: 'Minimum',  dataIndex: 'minimum_amount', flex: 1},
			{ header: 'Virtual',  dataIndex: 'virtual', flex: 1},
			{ header: 'Cust QTY',  dataIndex: 'customer_amount', flex: 1},
			{ header: 'UoM',  dataIndex: 'uom_name', flex: 1},
			{ header: 'Selling Price',  dataIndex: 'selling_price', flex: 1},
			{ header: 'Currency',  dataIndex: 'exchange_name', flex: 1},
			{	header: 'Deskripsi', dataIndex: 'description', flex: 1 } ,
			{	header: 'Untuk Dijual?', dataIndex: 'is_tradeable', flex: 1 } 
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit ',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete ',
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



		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, this.searchField ];
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying  {0} - {1} of {2}',
			emptyMsg: "N/A" 
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
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});
