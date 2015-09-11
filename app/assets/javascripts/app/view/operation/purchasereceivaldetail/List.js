Ext.define('AM.view.operation.purchasereceivaldetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.purchasereceivaldetaillist',

  	store: 'PurchaseReceivalDetails', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'Code', dataIndex: 'code', flex: 1},
			{
				xtype : 'templatecolumn',
				text : "Description",
				flex : 3,
				tpl : 	'Kode PO: <br />  <b>{purchase_order_code}</b>'  + '<br />' + '<br />' +
						'Nomor Surat PO : <br /> <b>{purchase_order_nomor_surat}</b>'  + '<br />' + '<br />' +
						'Kode Po Detail : <br /> <b>{purchase_order_detail_code}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "Item",
				flex : 3,
				tpl : 	'Sku: <br />  <b>{purchase_order_detail_item_sku}</b>'  + '<br />' + '<br />' +
						'Name : <br /> <b>{purchase_order_detail_item_name}</b>'
			},
			{
				xtype : 'templatecolumn',
				text : "Amount",
				flex : 3,
				tpl : 	'Qty : <br /> <b>{amount} {purchase_order_detail_item_uom_name}</b>'  + '<br />' + '<br />' +
						'Pending Receival QTY : <br /> <b>{purchase_order_detail_pending_receival_amount} {purchase_order_detail_item_uom_name}</b>' 
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
		this.setTitle("PurchaseReceival: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
