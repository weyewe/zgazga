Ext.define('AM.controller.TemporaryDeliveryOrderDetails', {
  extend: 'Ext.app.Controller',

  stores: ['TemporaryDeliveryOrderDetails', 'TemporaryDeliveryOrders'],
  models: ['TemporaryDeliveryOrderDetail'],

  views: [
    'operation.temporarydeliveryorderdetail.List',
    'operation.temporarydeliveryorderdetail.Form',
		'operation.temporarydeliveryorder.List'
  ],

  refs: [
		{
			ref: 'list',
			selector: 'temporarydeliveryorderdetaillist'
		},
		{
			ref : 'parentList',
			selector : 'temporarydeliveryorderlist'
		}
	],

  init: function() {
    this.control({
      'temporarydeliveryorderdetaillist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange ,
				afterrender : this.loadObjectList
      },
      'temporarydeliveryorderdetailform button[action=save]': {
        click: this.updateObject
      },

	 
      'temporarydeliveryorderdetaillist button[action=addObject]': {
        click: this.addObject
      },

			'temporarydeliveryorderdetaillist button[action=repeatObject]': {
        click: this.addObject
      },


      'temporarydeliveryorderdetaillist button[action=editObject]': {
        click: this.editObject
      },
      'temporarydeliveryorderdetaillist button[action=deleteObject]': {
        click: this.deleteObject
      },
 			'temporarydeliveryorderdetaillist textfield[name=searchField]': {
				change: this.liveSearch
			},
			// monitor parent(sales_order) update
			'temporarydeliveryorderlist' : {
				'updated' : this.reloadStore,
				'confirmed' : this.reloadStore,
				'deleted' : this.cleanList
			}
		
    });
  },
	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;
		
		
		if( newValue.length ==0 ){
			return; 
		}
 
		
		me.getTemporaryDeliveryOrderDetailsStore().getProxy().extraParams.livesearch = newValue; 
	  
		me.getTemporaryDeliveryOrderDetailsStore().load();
	},
	
	loadObjectList : function(me){
		me.getStore().loadData([],false);
	},

	reloadStore : function(record){
		var list = this.getList();
		var store = this.getTemporaryDeliveryOrderDetailsStore();
		
		store.load({
			params : {
				temporary_delivery_order_id : record.get('id')
			}
		});
		
		list.setObjectTitle(record);
	},
	
	cleanList : function(){
		var list = this.getList();
		var store = this.getTemporaryDeliveryOrderDetailsStore();
		
		list.setTitle('');
		// store.removeAll(); 
		store.loadRecords([], {addRecords: false});
	},
 

  addObject: function(button) {
		
		// I want to get the currently selected item 
		var record = this.getParentList().getSelectedObject();
		if(!record){
			return; 
		}
		 
		var widgetName = 'temporarydeliveryorderdetailform'; 
		
    var view = Ext.widget(widgetName , {
			parentRecord : record 
		});
		view.setParentData( record );
		
    view.show(); 
  },

  editObject: function() {
		var parentRecord = this.getParentList().getSelectedObject();
		
    var record = this.getList().getSelectedObject();
		if(!record || !parentRecord){
			return; 
		}


		var widgetName = 'temporarydeliveryorderdetailform';
		 
    var view = Ext.widget(widgetName, {
			parentRecord : parentRecord
		});

    view.down('form').loadRecord(record);
		view.setParentData( parentRecord );
		// console.log("selected record id: " + record.get('id'));
		// console.log("The selected poe id: " + record.get('purchase_order_entry_id'));
		view.setComboBoxData(record); 
  },

  updateObject: function(button) {
  	button.disable();
  	var me  = this; 
    var win = button.up('window');
    var form = win.down('form');

		var parentRecord = this.getParentList().getSelectedObject();
	
    var store = this.getTemporaryDeliveryOrderDetailsStore();
    var record = form.getRecord();
    var values = form.getValues();
		console.log("The values: " );
		console.log( values ) 
		
		if( record ){
			record.set( values );
			 
			form.query('checkbox').forEach(function(checkbox){
				record.set( checkbox['name']  ,checkbox['checked'] ) ;
			});
			
			form.setLoading(true);
			record.save({
				params : {
					temporary_delivery_order_id : parentRecord.get('id')
				},
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					// form.fireEvent('item_quantity_changed');
					store.load({
						params: {
							temporary_delivery_order_id : parentRecord.get('id')
						}
					});
					
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
		
			var newObject = new AM.model.TemporaryDeliveryOrderDetail( values ) ;
			
		 
			
			form.query('checkbox').forEach(function(record){
				newObject.set( record['name']  ,record['checked'] ) ;
			});
			
			// populate the checkbox value to the object 
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				params : {
					temporary_delivery_order_id : parentRecord.get('id')
				},
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load({
						params: {
							temporary_delivery_order_id : parentRecord.get('id')
						}
					});
					// form.fireEvent('item_quantity_changed');
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

  

	deleteObject: function() {
    var record = this.getList().getSelectedObject();
		if(!record){return;}
		var parent_id = record.get('temporary_delivery_order_id');
		var list  = this.getList();
		list.setLoading(true); 
		
    if (record) {
			record.destroy({
				success : function(record){
					list.setLoading(false);
					list.fireEvent('deleted');	
					// this.getList().query('pagingtoolbar')[0].doRefresh();
					// console.log("Gonna reload the shite");
					// this.getPurchaseOrdersStore.load();
					list.getStore().load({
						params : {
							temporary_delivery_order_id : parent_id
						}
					});
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

		// var record = this.getList().getSelectedObject();

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  }

});
