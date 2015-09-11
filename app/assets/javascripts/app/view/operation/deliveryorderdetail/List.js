Ext.define('AM.view.operation.deliveryorderdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.deliveryorderdetaillist',

  	store: 'DeliveryOrderDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{ header: 'Code', dataIndex: 'code', flex: 1},
				{
				xtype : 'templatecolumn',
				text : "Item",
				flex : 3,
				tpl : 	'Sku: <br />  <b>{sales_order_detail_item_sku}</b>'  + '<br />' + '<br />' +
						'Name: <br /> <b>{sales_order_detail_item_name}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "QTY",
				flex : 3,
				tpl : 	'Delivery QTY: <br />  <b>{amount}</b>'  + '<br />' + '<br />' +
						'PendingDelivery QTY: <br /> <b>{sales_order_detail_pending_delivery_amount}</b>'  
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
		this.setTitle("DeliveryOrder: " + record.get("code"));
	},
		
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
