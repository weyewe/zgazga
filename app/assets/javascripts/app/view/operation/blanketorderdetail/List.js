Ext.define('AM.view.operation.blanketorderdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blanketorderdetaillist',

  	store: 'BlanketOrderDetails', 
 

	initComponent: function() {
		this.columns = [
			
						{
					xtype : 'templatecolumn',
					text : "Blanket Info",
					flex : 3,
					tpl : 	'Blanket SKU:  <br /><b>{blanket_sku}</b>'    + '<br />' +
								'Nama: <br /><b>{blanket_name}</b>'  + '<br />' + '<br />' +
								
							'Roll Blanket SKU:  <br /><b>{blanket_roll_blanket_item_sku}</b>'    + '<br />' +
								'{blanket_roll_blanket_item_name}'  + '<br />' + '<br />' +	
								
							'Bar 1 SKU:  <br /><b>{blanket_left_bar_item_sku}</b>'    + '<br />' +
								'{blanket_left_bar_item_name}'  + '<br />' + '<br />' +
								
							'Bar 2 SKU:  <br /><b>{blanket_right_bar_item_sku}</b>'    + '<br />' +
								'<b>{blanket_right_bar_item_name}'  
				},
				{ header: 'Scheduled Qty', dataIndex: 'quantity', flex: 1},
				{
					xtype : 'templatecolumn',
					text : "Status Selesai",
					flex : 3,
					tpl : 	'Selesai: <br />  <b>{is_finished}</b>'  + '<br />' + '<br />' +
								'Tanggal: <br />  <b>{finished_at}</b>'   
					 
				},
				{
					xtype : 'templatecolumn',
					text : "Hasil",
					flex : 3,
					tpl : 		'Quantity Finish: <b>{finished_quantity}</b>' + '<br />' + '<br />' +
								'Quantity Reject: <b>{rejected_quantity}</b>' + '<br />' + '<br />' +
								
								'Penggunaan Roll Blanket: <br /> <b>{roll_blanket_usage}</b>' + '<br />' + '<br />' +
								'Defect Roll Blanket: <br /><b>{roll_blanket_defect}</b>'  + '<br />' + '<br />' +
								'Test Bar 1 Usage: <br /><b>{test_left_bar_usage}</b>'  + '<br />' + '<br />' +
								'Test Bar 2 Usage: <br /><b>{test_right_bar_usage}</b>' 
				},
		 
			// { header: 'Id', dataIndex: 'id', flex: 1},
			// { header: 'Blanket Sku',  dataIndex: 'blanket_sku', flex: 1},
   // 		{ header: 'Blanket Name',  dataIndex: 'blanket_name', flex: 1},
   // 		{ header: 'Roll Blanket Sku',  dataIndex: 'blanket_roll_blanket_item_sku', flex: 1},
   // 		{ header: 'Roll Blanket Name',  dataIndex: 'blanket_roll_blanket_item_name', flex: 1},
   // 		{ header: 'LeftBar Sku', dataIndex: 'blanket_left_bar_item_sku', flex: 1},
   // 		{ header: 'LeftBar name', dataIndex: 'blanket_left_bar_item_name', flex: 1},
   // 		{ header: 'RightBar sku', dataIndex: 'blanket_right_bar_item_sku', flex: 1},
   // 		{ header: 'RightBar name', dataIndex: 'blanket_right_bar_item_name', flex: 1},
   // 		{ header: 'Rejected Date', dataIndex: 'rejected_date', flex: 1},
   // 		{ header: 'Finished Date', dataIndex: 'finished_at', flex: 1},
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
		this.setTitle("BlanketOrder: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
