Ext.define('AM.view.master.menudetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.menudetaillist',
	requires: ['Ext.ux.CheckColumn'],
  	store: 'MenuDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{ header: 'Name', dataIndex: 'name', flex: 1},
		 
			{
	            xtype: 'checkcolumn',
	            header: 'View',
	            dataIndex: 'is_view_allowed',
	            width: 70
	        },
			{
	            xtype: 'checkcolumn',
	            header: 'Create',
	            dataIndex: 'is_create_allowed',
	            width: 70
	        },
			{
	            xtype: 'checkcolumn',
	            header: 'Edit',
	            dataIndex: 'is_update_allowed',
	            width: 70
	        },
			{
	            xtype: 'checkcolumn',
	            header: 'Confirm',
	            dataIndex: 'is_confirm_allowed',
	            width: 70
	        },
      		{
	            xtype: 'checkcolumn',
	            header: 'Unconfirm',
	            dataIndex: 'is_unconfirm_allowed',
	            width: 70
	        },
      		{
	            xtype: 'checkcolumn',
	            header: 'Delete',
	            dataIndex: 'is_delete_allowed',
	            width: 70
	        }
			
			 
		];
		
		this.selModel =  {
            selType: 'cellmodel'
        };
		

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


		this.tbar = [this.addObjectButton,  this.editObjectButton, this.deleteObjectButton ]; 
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
		this.setTitle("Menu: " + record.get("code"));
	}
});
