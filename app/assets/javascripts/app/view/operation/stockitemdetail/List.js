Ext.define('AM.view.operation.stockitemdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.stockitemdetaillist',

  	store: 'StockItemDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{
				xtype : 'templatecolumn',
				text : "Warehouse",
				flex : 3,
				tpl : 	'Name: <br />  <b>{warehouse_name}</b> '  + '<br />' + '<br />' +
							'Code: <br /><b>{warehouse_code}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Quantity",
				flex : 3,
				tpl : 	' <b>{amount}</b> {item_uom_name}' +  '<br />' + '<br />' +
						'Customer Amount : {customer_amount}'
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
		

		this.tbar =  ['->', this.searchField  ];
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
		this.setTitle("StockItem: " + record.get("sku"));
	}
});
