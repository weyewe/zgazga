Ext.define('AM.view.operation.rolleridentificationformdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.rolleridentificationformdetaillist',

  	store: 'RollerIdentificationFormDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			// { header: 'RIF Id', dataIndex: 'detail_id', flex: 1},
			// { header: 'Roller No',  dataIndex: 'roller_no', flex: 1},
   // 		{ header: 'Material',  dataIndex: 'material_case_text', flex: 1},
   // 		{ header: 'Core SKU',  dataIndex: 'core_builder_sku', flex: 2},
   // 		{ header: 'Core',  dataIndex: 'core_builder_name', flex: 2},
    		// { header: 'Roller Type',  dataIndex: 'roller_type_name', flex: 2},
    		// { header: 'Machine',  dataIndex: 'machine_name', flex: 2},
    		// { header: 'Repair',  dataIndex: 'repair_request_case_text', flex: 2},
    		// { header: 'RD',  dataIndex: 'rd', flex: 1},
    		// { header: 'CD',  dataIndex: 'cd', flex: 1},
    		// { header: 'WL',  dataIndex: 'wl', flex: 1},
    		// { header: 'TL',  dataIndex: 'gl', flex: 1},
    		// { header: 'Groove Length',  dataIndex: 'groove_length', flex: 1},
    		// { header: 'QTY Grooves',  dataIndex: 'groove_amount', flex: 1},
    		
    		
    		{
				xtype : 'templatecolumn',
				text : "Core",
				flex : 3,
				tpl : 	'Nomor Identifikasi: <br /> <b>{detail_id}</b>'  + '<br />' + '<br />' +
							'Nomor Roller: <br /> <b>{roller_no}</b>'  + '<br />' + '<br />' +
							'Material: <br /> <b>{material_case_text}</b>'  + '<br />' + '<br />' +
							
							'Core SKU: <br /> <b>{core_builder_sku}</b>'  + '<br />' + '<br />' +
							'Core: <br /> <b>{core_builder_name}</b>'   
			},
			
	 
			{
				xtype : 'templatecolumn',
				text : "Roller",
				flex : 3,
				tpl : 	'Roller Type: <br /> <b>{roller_type_name}</b>'  + '<br />' + '<br />' +
							'Machine: <br /> <b>{machine_name}</b>'  + '<br />' + '<br />' +
							'Repair: <br /> <b>{repair_request_case_text}</b>' 
			},
			
 
			
			{
				xtype : 'templatecolumn',
				text : "Metric",
				flex : 3,
				tpl : 	'RD:  <b>{rd}</b>'  + '<br />' + 
						'CD:  <b>{cd}</b>'  + '<br />' + 
						'WL:  <b>{wl}</b>'  + '<br />' + 
						'TL:  <b>{tl}</b>'  + '<br />' +  '<br />' + 
							'Groove Length: <br /> <b>{groove_length}</b>'  + '<br />' +  
							'Qty Groove: <br /> <b>{groove_amount}</b>' 
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
		this.setTitle("RollerIdentificationForm: " + record.get("code"));
	},
	
	refreshSearchField : function(){
		this.searchField.setValue("");
	}	
});
