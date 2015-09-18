Ext.define('AM.view.report.neracasaldo.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.neracasaldolist',

  	store: 'NeracaSaldos', 
 

	initComponent: function() {
		this.columns = [
			
			{ 	header: 'Period',  dataIndex: 'period', flex: 1},
			{ 	header: 'Year',  dataIndex: 'year_period', flex: 1},
			{	header: 'Beginning', dataIndex: 'beginning_period', flex: 2 },
			{	header: 'End Date', dataIndex: 'end_date_period', flex: 2 },
			{	header: 'AR/AP inclusive', dataIndex: 'is_year_closing', flex: 2 },
			{
				xtype : 'templatecolumn',
				text : "Closing",
				flex : 3,
				tpl : 	'Status Closing:  <b>{is_closed}</b>'  + '<br />' + '<br />' +
							'Tanggal Closing: <b>{closed_at}</b>' 
			},
			
			
		];

		this.printObjectButton = new Ext.Button({
			text: 'Print',
			action: 'printObject'
		});
		
		this.printPosNeracaObjectButton = new Ext.Button({
			text: 'Print Perincian Neraca',
			action: 'printPosNeracaObjectButton'
		});
		
		this.printIncomeStatementObjectButton = new Ext.Button({
			text: 'Print Income Statement',
			action: 'printIncomeStatementObjectButton'
		});
		
		this.tbar = [this.printObjectButton,	this.printPosNeracaObjectButton,
					 this.printIncomeStatementObjectButton
		
						
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
});
