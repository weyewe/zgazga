Ext.define("AM.controller.Operation", {
	extend : "AM.controller.BaseTreeBuilder",
	views : [
		"operation.OperationProcessList",
		'OperationProcessPanel',
		'Viewport'
	],

	 
	
	refs: [
		{
			ref: 'operationProcessPanel',
			selector: 'operationProcessPanel'
		} ,
		{
			ref: 'operationProcessList',
			selector: 'operationProcessList'
		}  
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		// console.log("starting the init in Operation.js");
		me.control({
			"operationProcessPanel" : {
				activate : this.onActiveProtectedContent,
				deactivate : this.onDeactivated
			} 
			
		});
		
	},
	
	onDeactivated: function(){
		// console.log("Operation process panel is deactivated");
		var worksheetPanel = Ext.ComponentQuery.query("operationProcessPanel #operationWorksheetPanel")[0];
		worksheetPanel.setTitle(false);
		// worksheetPanel.setHeader(false);
		worksheetPanel.removeAll();		 
		var defaultWorksheet = Ext.create( "AM.view.operation.Default");
		worksheetPanel.add(defaultWorksheet); 
	},
	
	 
  salesFolder : {
		text 			: "Penjualan", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'SalesOrder', 
				viewClass:'AM.view.operation.SalesOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'DeliveryOrder', 
				viewClass:'AM.view.operation.DeliveryOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'delivery_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Sales Invoice', 
				viewClass:'AM.view.operation.SalesInvoice', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'sales_invoices',
						action : 'index'
					}
				]
			}, 
 
			 
		]
	},
	
	purchaseFolder : {
		text 			: "Pembelian", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'PurchaseOrder', 
				viewClass:'AM.view.operation.PurchaseOrder', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_orders',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Penerimaan', 
				viewClass:'AM.view.operation.PurchaseReceival', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_receivals',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Purchase Invoice', 
				viewClass:'AM.view.operation.PurchaseInvoice', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'purchase_invoices',
						action : 'index'
					}
				]
			}, 
 
			 
		]
	},
	
	logisticFolder : {
		text 			: "Logistic", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Penyesuaian Stock', 
				viewClass:'AM.view.operation.StockAdjustment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'stock_adjustments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Pindah Gudang', 
				viewClass:'AM.view.operation.WarehouseMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'warehouse_mutations',
						action : 'index'
					}
				]
			}, 
 
 
			 
		]
	},
 
  
  financeFolder : {
		text 			: "Finance", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'PaymentRequest', 
				viewClass:'AM.view.operation.PaymentRequest', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'payment_requests',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'PaymentVoucher', 
				viewClass:'AM.view.operation.PaymentVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'payment_vouchers',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'ReceiptVoucher', 
				viewClass:'AM.view.operation.ReceiptVoucher', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'receipt_vouchers',
						action : 'index'
					}
				]
			}, 
 
			 
		]
	},
	
	cashbankFolder : {
		text 			: "Cash dan Bank", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Adjustment', 
				viewClass:'AM.view.operation.CashBankAdjustment', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'cash_bank_adjustments',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Mutation', 
				viewClass:'AM.view.operation.CashBankMutation', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'cash_bank_mutations',
						action : 'index'
					}
				]
			}, 
		]
	},
	
	accountingFolder : {
		text 			: "Accounting", 
		viewClass : '',
		iconCls		: 'text-folder', 
    	expanded	: true,
		children 	: [
        	{ 
				text:'Memorial', 
				viewClass:'AM.view.operation.Memorial', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'memorials',
						action : 'index'
					}
				]
			}, 
			{ 
				text:'Closing', 
				viewClass:'AM.view.operation.Closing', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'closings',
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
			this.logisticFolder,
			this.salesFolder,
			this.purchaseFolder,
 			this.financeFolder,
 			this.accountingFolder,
 			this.cashbankFolder
 			
		];
		
		var processList = panel.down('operationProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
	},
});