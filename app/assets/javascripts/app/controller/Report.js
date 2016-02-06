Ext.define("AM.controller.Report", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"report.ReportProcessList",
		'ReportProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'reportProcessPanel',
			selector: 'reportProcessPanel'
		} ,
		{
			ref: 'reportProcessList',
			selector: 'reportProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		console.log("starting the init in Report.js");
		me.control({
			"reportProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Report process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("reportProcessPanel #reportWorksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.report.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 

	financeFolder : {
		text 			: "Finance Report", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
 
			{ 
				text:'AP', 
				viewClass:'AM.view.report.Payable', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'payables',
					action : 'index'
				}
				]
			},   
			
			{ 
				text:'AR', 
				viewClass:'AM.view.report.Receivable', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},  
    ]
	},
	
	accountingFolder : {
		text 			: "Accounting Report", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
 			{ 
				text:'Neraca', 
				viewClass:'AM.view.report.NeracaSaldo', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'neraca_saldos',
					action : 'index'
				}
				]
			},  
			// { 
			// 	text:'Perincian Neraca', 
			// 	viewClass:'AM.view.report.PosNeraca', 
			// 	leaf:true, 
			// 	iconCls:'text',
			// 	conditions : [
			// 	{
			// 		controller : 'kartu_buku_besars',
			// 		action : 'index'
			// 	}
			// 	]
			// },  
			{ 
				text:'KartuBukuBesar', 
				viewClass:'AM.view.report.KartuBukuBesar', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'kartu_buku_besars',
					action : 'index'
				}
				]
			},   
			
			
    ]
	},
	
	
	
	profitLossFolder : {
		text 			: "Laba Rugi", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        
			{ 
				text:'Bulan Berjalan', 
				viewClass:'AM.view.report.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},  
			{ 
				text:'Bulan Berjalan Kumulatif', 
				viewClass:'AM.view.report.Menu', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'menus',
					action : 'index'
				}
				]
			},   
			
			{ 
				text:'12 bulan', 
				viewClass:'AM.view.report.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},   
			  
 
  
    ]
	},
	
	balanceSheetFolder : {
		text 			: "Neraca", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        
			{ 
				text:'Neraca', 
				viewClass:'AM.view.report.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},  
			{ 
				text:'Pos Neraca', 
				viewClass:'AM.view.report.Menu', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'menus',
					action : 'index'
				}
				]
			},   
			
			{ 
				text:'Neraca Saldo (Ledger)', 
				viewClass:'AM.view.report.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'users',
					action : 'index'
				}
				]
			},   
			  
 
  
    ]
	},
	penjualanFolder : {
		text 			: "Penjualan", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        
			{ 
				text:'SalesOrder', 
				viewClass:'AM.view.report.SalesOrderReport', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'salesorderreports',
					action : 'index'
				}
				]
			},  
			
			  
 
  
    ]
	},
	
	pembelianFolder : {
		text 			: "Pembelian", 
		viewClass : '',
		iconCls		: 'text-folder', 
		expanded	: true,
		children 	: [
        
			{ 
				text:'PurchaseOrder', 
				viewClass:'AM.view.report.PurchaseOrderReport', 
				leaf:true, 
				iconCls:'text',
				conditions : [
				{
					controller : 'purchaseorderreports',
					action : 'index'
				}
				]
			},  
			
			  
 
  
    ]
	},
	
	onActiveProtectedContent: function( panel, options) {
		var me  = this; 
		var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		var email = currentUser['email'];
		
		me.folderList = [
			this.financeFolder,
			this.accountingFolder,
			this.profitLossFolder,
			this.balanceSheetFolder,
			this.penjualanFolder,
			this.pembelianFolder,
		];
		
		console.log("Inside the report");
		
		var processList = panel.down('reportProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});