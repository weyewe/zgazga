Ext.define('AM.controller.PurchaseDownPayments', {
  extend: 'Ext.app.Controller',

  stores: ['PurchaseDownPayments'],
  models: ['PurchaseDownPayment'],

  views: [
    'operation.purchasedownpayment.List',
    'operation.purchasedownpayment.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'purchasedownpaymentlist'
		},
		{
			ref : 'searchField',
			selector: 'purchasedownpaymentlist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'purchasedownpaymentlist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'purchasedownpaymentform button[action=save]': {
        click: this.updateObject
      },
      'purchasedownpaymentlist button[action=addObject]': {
        click: this.addObject
      },
      'purchasedownpaymentlist button[action=editObject]': {
        click: this.editObject
      },
      'purchasedownpaymentlist button[action=deleteObject]': {
        click: this.deleteObject
      },
	  	'purchasedownpaymentlist textfield[name=searchField]': {
        change: this.liveSearch
      },
			'purchasedownpaymentProcess purchasedownpaymentlist button[action=confirmObject]': {
        click: this.confirmObject
			}	,

			'purchasedownpaymentProcess purchasedownpaymentlist button[action=unconfirmObject]': {
        click: this.unconfirmObject
			}	,
	  	'confirmpurchasedownpaymentform button[action=confirm]' : {
				click : this.executeConfirm
			},

			'unconfirmpurchasedownpaymentform button[action=confirm]' : {
				click : this.executeUnconfirm
			},
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getPurchaseDownPaymentsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getPurchaseDownPaymentsStore().load();
	},
	
 

	loadObjectList : function(me){
		me.getStore().getProxy().extraParams = {}
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('purchasedownpaymentform');
    view.show();
  },

  editObject: function() {
		var me = this; 
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('purchasedownpaymentform');

		

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

  updateObject: function(button) {
		var me = this; 
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getPurchaseDownPaymentsStore();
    var record = form.getRecord();
    var values = form.getValues();


	 
		
		
		if( record ){
			record.set( values );
			
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			 
			form.setLoading(true);
			record.save({
				success : function(new_record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					var list = me.getList();
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );         
					
					// store.getProxy().extraParams = {
					//     livesearch: ''
					// };
	 
					// store.load();
					win.close();
				},
				failure : function(record,op ){
					button.enable();
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.PurchaseDownPayment( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
	
					store.load();
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					button.enable();
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },
	
	confirmObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('confirmpurchasedownpaymentform');

			view.setParentData( record );
	    view.show();
		}
		
		
		// this.reloadRecordView( record, view ) ; 
	},
	
	unconfirmObject: function(){
		// console.log("the startObject callback function");
		var view = Ext.widget('unconfirmpurchasedownpaymentform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
		// this.reloadRecordView( record, view ) ; 
	},
	
	executeConfirm: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getPurchaseDownPaymentsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					confirm: true 
				},
				success : function(new_record){
					form.setLoading(false);
					
					// me.reloadRecord( record ) ; 
					
					list.enableRecordButtons();  
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );      
					AM.view.Constants.highlightSelectedRow( list );     
					
					
					win.close();
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	},
	
	
	
	executeUnconfirm: function(button){
		var me = this; 
		var win = button.up('window');
    var form = win.down('form');
		var list = this.getList();

    var store = this.getPurchaseDownPaymentsStore();
		var record = this.getList().getSelectedObject();
    var values = form.getValues();
 
		if(record){
			var rec_id = record.get("id");
			record.set( 'confirmed_at' , values['confirmed_at'] );
			 
			// form.query('checkbox').forEach(function(checkbox){
			// 	record.set( checkbox['name']  ,checkbox['checked'] ) ;
			// });
			// 
			form.setLoading(true);
			record.save({
				params : {
					unconfirm: true 
				},
				success : function(new_record){
					form.setLoading(false);
					
					// me.reloadRecord( record ) ; 
					list.enableRecordButtons();  
					AM.view.Constants.updateRecord( record, new_record );  
					AM.view.Constants.highlightSelectedRow( list );      
					AM.view.Constants.highlightSelectedRow( list );     
					
					win.close();
				},
				failure : function(record,op ){
					// console.log("Fail update");
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject(); 
					// this.reject(); 
				}
			});
		}
	},
	
  deleteObject: function() {
	  var record = this.getList().getSelectedObject();
		if(!record){return;} 
		var list  = this.getList();
		list.setLoading(true); 
		
    if (record) {
			record.destroy({
				success : function(record){
					list.setLoading(false);
					// list.fireEvent('deleted');	
					// this.getList().query('pagingtoolbar')[0].doRefresh();
					// console.log("Gonna reload the shite");
					// this.getPurchaseOrdersStore.load();
					list.getStore().load();
				},
				failure : function(record,op ){
					list.setLoading(false);
					
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					
					if( errors["generic_errors"] ){
						Ext.MessageBox.show({
						           title: 'DELETE FAIL',
						           msg: errors["generic_errors"],
						           buttons: Ext.MessageBox.OK, 
						           icon: Ext.MessageBox.ERROR
						       });
					}
					
				}
			});
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  }

});
