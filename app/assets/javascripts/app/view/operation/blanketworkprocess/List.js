Ext.define('AM.view.operation.blanketworkprocess.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blanketworkprocesslist',

  	store: 'BlanketWorkProcesss', 
 

	initComponent: function() {
		this.columns = [
				{ header: 'Id', dataIndex: 'id', flex: 1},
				{ header: 'Blanket Sku',  dataIndex: 'blanket_sku', flex: 1},
				{ header: 'Blanket Name',  dataIndex: 'blanket_name', flex: 1},
				{ header: 'Roll Blanket Sku',  dataIndex: 'blanket_roll_blanket_item_sku', flex: 1},
				{ header: 'Roll Blanket Name',  dataIndex: 'blanket_roll_blanket_item_name', flex: 1},
				{ header: 'LeftBar Sku', dataIndex: 'blanket_left_bar_item_sku', flex: 1},
				{ header: 'LeftBar name', dataIndex: 'blanket_left_bar_item_name', flex: 1},
				{ header: 'RightBar sku', dataIndex: 'blanket_right_bar_item_sku', flex: 1},
				{ header: 'RightBar name', dataIndex: 'blanket_right_bar_item_name', flex: 1},
				{ header: 'Rejected Date', dataIndex: 'rejected_date', flex: 1},
				{ header: 'Finished Date', dataIndex: 'finished_at', flex: 1},
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
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		this.finishObjectButton = new Ext.Button({
			text: 'Finish',
			action: 'finishObject',
			disabled: true
		});
	
		this.unfinishObjectButton = new Ext.Button({
			text: 'Unfinish',
			action: 'unfinishObject',
			disabled: true,
			hidden : true
		});



		this.tbar = [
		    	        this.finishObjectButton,
						this.unfinishObjectButton,
		 				'-',
						
						'->',this.searchField,
					
						
		];
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
		
		if( selectedObject && selectedObject.get("is_finished") == true ){
			this.finishObjectButton.hide();
			this.unfinishObjectButton.show();
			this.unfinishObjectButton.enable();
		}else{
			this.finishObjectButton.enable();
			this.finishObjectButton.show();
			this.unfinishObjectButton.hide();
		}


	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.finishObjectButton.disable(); 
	}
});