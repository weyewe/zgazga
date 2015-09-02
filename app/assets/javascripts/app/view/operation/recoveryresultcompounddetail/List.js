Ext.define('AM.view.operation.recoveryresultcompounddetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.recoveryresultcompounddetaillist',

  	store: 'RecoveryResultCompoundDetails', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'Compound Batch', dataIndex: 'batch_instance_name', flex: 1},
			{ header: 'Finish (kg)',  dataIndex: 'finish_amount', flex: 1},
    		{ header: 'Reject (kg)',  dataIndex: 'reject_amount', flex: 1},
    		{ header: 'Defect (kg)',  dataIndex: 'defect_amount', flex: 2}, 
			
			 
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
		
		this.tbar = [this.addObjectButton, this.deleteObjectButton , '->', 
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
		this.setTitle("Alokasi batch compound untuk  RIF: "  + record.get("roller_identification_form_detail_id"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}
});
