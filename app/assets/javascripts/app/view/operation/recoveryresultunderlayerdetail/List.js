Ext.define('AM.view.operation.recoveryresultunderlayerdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.recoveryresultunderlayerdetaillist',

  	store: 'RecoveryResultUnderlayerDetails', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'Underlayer Batch', dataIndex: 'batch_instance_name', flex: 1},
			{ header: 'Finish (meter)',  dataIndex: 'finish_amount', flex: 1},
    		{ header: 'Reject (meter)',  dataIndex: 'reject_amount', flex: 1},
    		{ header: 'Defect (meter)',  dataIndex: 'defect_amount', flex: 2},  
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


		this.tbar = [this.addObjectButton, this.deleteObjectButton ]; 
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
		this.setTitle("Alokasi batch underlayer untuk  RIF: "  + record.get("roller_identification_form_detail_id"));
	}
});