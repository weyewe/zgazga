Ext.define('AM.controller.PurchaseInvoices', {
  extend: 'Ext.app.Controller',

  stores: ['PurchaseInvoices'],
  models: ['PurchaseInvoice'],

  views: [
    'operation.purchaseinvoice.List',
    'operation.purchaseinvoice.Form',
		'operation.purchaseinvoicedetail.List',
		'Viewport'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'purchaseinvoicelist'
		},
		{
			ref : 'purchaseInvoiceDetailList',
			selector : 'purchaseinvoicedetaillist'
		},
		
		{
			ref : 'form',
			selector : 'purchaseinvoiceform'
		},
		{
			ref: 'viewport',
			selector: 'vp'
		},
	],

  init: function() {
    this.control({
      'purchaseinvoiceProcess purchaseinvoicelist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'purchaseinvoiceProcess purchaseinvoiceform button[action=save]': {
        click: this.updateObject
      },
			'purchaseinvoiceProcess purchaseinvoiceform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'purchaseinvoiceProcess purchaseinvoicelist button[action=addObject]': {
        click: this.addObject
      },
      'purchaseinvoiceProcess purchaseinvoicelist button[action=editObject]': {
        click: this.editObject
      },
      'purchaseinvoiceProcess purchaseinvoicelist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			
			'purchaseinvoiceProcess purchaseinvoicelist button[action=confirmObject]': {
        click: this.confirmObject
      },

			'purchaseinvoiceProcess purchaseinvoicelist button[action=unconfirmObject]': {
        click: this.unconfirmObject
      },
			'confirmpurchaseinvoiceform button[action=confirm]' : {
				click : this.executeConfirm
			},
			
			'unconfirmpurchaseinvoiceform button[action=confirm]' : {
				click : this.executeUnconfirm
			},

			'purchaseinvoiceProcess purchaseinvoicelist textfield[name=searchField]': {
				change: this.liveSearch
			},
			'purchaseinvoiceform button[action=save]': {
        click: this.updateObject
      }
		
    });
  },

	onColorPickerSelect: function(colorId, theColorPicker){
		var win = theColorPicker.up('window');
    var form = win.down('form');
		var colorField = form.getForm().findField('color'); 
		
		
		// console.log("the colorId in onColorPickerSelect:");
		// console.log( colorId);
		colorField.setValue( colorId );
		
		// console.log("The colorField.getValue()");
		// console.log( colorField.getValue() );
	
	},

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getPurchaseInvoicesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getPurchaseInvoicesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log( "I am inside the load object list" ); 
		me.getStore().load();
	},

  addObject: function() {
	var view = Ext.widget('purchaseinvoiceform');
  view.show();

	 
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('purchaseinvoiceform');

    view.down('form').loadRecord(record);
    view.setComboBoxData( record ) ;
  },

	confirmObject: function(){
		// console.log("the startObject callback function");
		var record = this.getList().getSelectedObject();
		if(record){
			var view = Ext.widget('confirmpurchaseinvoiceform');

			view.setParentData( record );
	    view.show();
		}
		
		
		// this.reloadRecordView( record, view ) ; 
	},

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getPurchaseInvoicesStore();
    var record = form.getRecord();
    var values = form.getValues();
 
		if( record ){
			record.set( values );
			  
			
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					win.close();
					// me.updateChildGrid(record );
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					me.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			console.log("This is the new record")
			var me  = this; 
			var newObject = new AM.model.PurchaseInvoice( values ) ; 
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					// console.log("create new record");
					// console.log( record )
					
					store.load();
					form.setLoading(false);
					win.close();
					// console.log("The record details");
					// console.log(record);
					me.updateChildGrid(record );
					
				},
				failure: function( record, op){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },

	unconfirmObject: function(){
		// console.log("the startObject callback function");
		var view = Ext.widget('unconfirmpurchaseinvoiceform');
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

    var store = this.getPurchaseInvoicesStore();
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
				success : function(record){
					form.setLoading(false);
					
					me.reloadRecord( record ) ; 
					
					list.enableRecordButtons(); 
					
					
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

    var store = this.getPurchaseInvoicesStore();
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
				success : function(record){
					form.setLoading(false);
					
					me.reloadRecord( record ) ; 
					list.enableRecordButtons(); 
					
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

    if (record) {
      var store = this.getPurchaseInvoicesStore();
			store.remove(record);
			store.sync( );
 
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();
		var me= this;
		var record = this.getList().getSelectedObject();
		if(!record){
			return; 
		}
		
		
		me.updateChildGrid(record );
		
		
		

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  },

	updateChildGrid: function(record){
		var templateDetailGrid = this.getPurchaseInvoiceDetailList();
		// templateDetailGrid.setTitle("Purchase Order: " + record.get('code'));
		templateDetailGrid.setObjectTitle( record ) ;
		
		// console.log("record id: " + record.get("id"));
		
		templateDetailGrid.getStore().getProxy().extraParams.purchase_invoice_id =  record.get('id') ;
		 
		templateDetailGrid.getStore().load({
			params : {
				purchase_invoice_id : record.get('id')
			},
			callback : function(records, options, success){
				templateDetailGrid.enableAddButton(); 
			}
		});
		
	},
	
	reloadRecord: function(record){
		
		var list = this.getList();
		var store = this.getList().getStore();
		var modifiedId = record.get('id');
		
		// console.log("modifiedId:  " + modifiedId);
		 
		AM.model.PurchaseInvoice.load( modifiedId , {
		    scope: list,
		    failure: function(record, operation) {
		        //do something if the load failed
		    },
		    success: function(new_record, operation) {
					// console.log("The new record");
					// 				console.log( new_record);
					recToUpdate = store.getById(modifiedId);
					recToUpdate.set(new_record.getData());
					recToUpdate.commit();
					list.getView().refreshNode(store.indexOfId(modifiedId));
		    },
		    callback: function(record, operation) {
		        //do something whether the load succeeded or failed
		    }
		});
	},

	


});
