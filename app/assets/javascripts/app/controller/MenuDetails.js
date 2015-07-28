Ext.define('AM.controller.MenuDetails', {
  extend: 'Ext.app.Controller',

  stores: ['MenuDetails', 'Menus'],
  models: ['MenuDetail'],

  views: [
    'master.menudetail.List',
    'master.menudetail.Form',
		'master.menu.List'
  ],

  refs: [
		{
			ref: 'list',
			selector: 'menudetaillist'
		},
		{
			ref : 'parentList',
			selector : 'menulist'
		}
	],

  init: function() {
    this.control({
      'menudetaillist': {
        // itemdblclick: this.editObject,
        selectionchange: this.selectionChange ,
				afterrender : this.loadObjectList
      },
      'menudetailform button[action=save]': {
        click: this.updateObject
      },

	 
      'menudetaillist button[action=addObject]': {
        click: this.addObject
      },

			'menudetaillist button[action=repeatObject]': {
        click: this.addObject
      },


      'menudetaillist button[action=editObject]': {
        click: this.editObject
      },
      'menudetaillist button[action=deleteObject]': {
        click: this.deleteObject
      },
 
 
			'menudetaillist checkcolumn': {
				'checkchange' : this.updateAuthorization
			},
			
			'menulist' : {
				'updated' : this.reloadStore,
				'confirmed' : this.reloadStore,
				'deleted' : this.cleanList
			}
		
    });
  },
  
 
  updateAuthorization: function(param1, param2   , param3 ){
  	var me = this; 
  	var theList  = this.getList(); 
  	console.log("inside update AUth");
  	console.log( param1  ) ;
  	console.log("probing param1: ");
  	console.log( param1["dataIndex"]) ; 
  	console.log( param2 );
  	console.log( param3 );
  	
  	var dataIndex = param1["dataIndex"]; 
  	
  	// get the model
  	// if param3 == true
  	// create menu_action_assignment
  	
  	var selected_record_node = this.getList().getView().getNode( param2 );
  	
  	// console.log("The selected record node:");
  	// console.log( selected_record_node );
  	
  	var selected_record =  this.getList().getView().getRecord( selected_record_node );
  	
  	// console.log(" the selected record");
  	// console.log( selected_record );
  	
  	console.log("dataIndex: " + dataIndex + " , value: "  + param3);
  	
  	selected_record.set(  dataIndex, param3 );
  	
  	
  	console.log( "The selected record after update");
  	console.log( selected_record);
  	
  	// var me =this ; 
  	// var list = me.getList();
  	

		theList.setLoading(true);
 		selected_record.save({
 			params: {
 				targetField: dataIndex 
 			},
 			
			success : function(new_record){
				
				AM.view.Constants.updateRecord( selected_record, new_record );  
 				theList.setLoading(false); 
			},
			failure : function(record,op ){ 
				theList.setLoading(false);

			}
		}); 
	
  	
  	// if param3 == false 
  	// delete menu action_assignment 
  	

				
			 
  	
  },

	loadObjectList : function(me){
		me.getStore().loadData([],false);
	},

	reloadStore : function(record){
		var list = this.getList();
		var store = this.getMenuDetailsStore();
		
		store.load({
			params : {
				menu_id : record.get('id')
			}
		});
		
		list.setObjectTitle(record);
	},
	
	cleanList : function(){
		var list = this.getList();
		var store = this.getMenuDetailsStore();
		
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
		 
		var widgetName = 'menudetailform'; 
		
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


		var widgetName = 'menudetailform';
		 
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
	
    var store = this.getMenuDetailsStore();
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
					menu_id : parentRecord.get('id')
				},
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					// form.fireEvent('item_quantity_changed');
					store.load({
						params: {
							menu_id : parentRecord.get('id')
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
		
			var newObject = new AM.model.MenuDetail( values ) ;
			
		 
			
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
					menu_id : parentRecord.get('id')
				},
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load({
						params: {
							menu_id : parentRecord.get('id')
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
		var parent_id = record.get('menu_id');
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
							menu_id : parent_id
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
