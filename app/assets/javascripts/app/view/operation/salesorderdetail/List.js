Ext.define('AM.view.operation.salesorderdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.salesorderdetaillist',

  	store: 'SalesOrderDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{ header: 'Code', dataIndex: 'code', flex: 1},
			{
				xtype : 'templatecolumn',
				text : "Item",
				flex : 3,
				tpl : 	'Sku: <br />  <b>{item_sku}</b>'  + '<br />' + '<br />' +
						'Name : <br /> <b>{item_name}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "Amount",
				flex : 3,
				tpl : 	'Qty : <br /> <b>{amount} {item_uom_name} </b>'  + '<br />' + '<br />' +
						'Value Per Pcs : <br /> <b>{price}</b>'  + '<br />' + '<br />' +
						'Pending Delivery QTY : <br /> <b>{pending_delivery_amount} {item_uom_name}</b>' 
			},
    		{ header: 'Status',  dataIndex: 'is_service_text', flex: 1},
			
			 
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
		this.setTitle("SalesOrder: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
