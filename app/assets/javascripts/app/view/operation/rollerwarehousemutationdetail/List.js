Ext.define('AM.view.operation.rollerwarehousemutationdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.rollerwarehousemutationdetaillist',

  	store: 'RollerWarehouseMutationDetails', 
 

	initComponent: function() {
		this.columns = [
		 	{ header: 'Code', dataIndex: 'code', flex: 1},
				{
					xtype : 'templatecolumn',
					text : "Roller Info",
					flex : 3,
					tpl : 	' SKU:  <br /><b>{item_sku}</b>'    + '<br />' +
							'Nama: <br /><b>{item_name}</b>' 
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
		this.setTitle("RollerWarehouseMutation: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
