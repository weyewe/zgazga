
Ext.define('AM.view.operation.warehousemutation.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.warehousemutationform',

  title : 'Add / Edit WarehouseMutation',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	var me = this; 
	
	var remoteJsonStoreWarehouse = Ext.create(Ext.data.JsonStore, {
		storeId : 'warehouse_search',
		fields	: [
		 		{
					name : 'warehouse_name',
					mapping : "name"
				} ,
				{
					name : 'warehouse_description',
					mapping : "description"
				} ,
		 
				{
					name : 'warehouse_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_warehouses',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
		
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [
    			{
        	        xtype: 'hidden',
        	        name : 'id',
        	        fieldLabel: 'id'
    	        },
    	        {
    		        xtype: 'displayfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		    },
    		    {
    					xtype: 'datefield',
    					name : 'mutation_date',
    					fieldLabel: 'Tanggal Mutasi',
    					format: 'Y-m-d',
    				},
    				{
	    				fieldLabel: 'Warehouse From',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'warehouse_name',
	    				valueField : 'warehouse_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreWarehouse , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{warehouse_name}">' + 
	    												'<div class="combo-name">{warehouse_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {warehouse_description}</div>' + 
	    						 					'</div>';
	    					}
	    				},
	    				name : 'warehouse_from_id' 
    				},
    				{
	    				fieldLabel: 'Warehouse To',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'warehouse_to_name',
	    				valueField : 'warehouse_to_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreWarehouse , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{warehouse_name}">' + 
	    												'<div class="combo-name">{warehouse_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {warehouse_description}</div>' + 
	    						 					'</div>';
	    					}
	    				},
	    				name : 'warehouse_to_id' 
    				},
			
			]
    }];

    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },
  
  
  setSelectedWarehouseSource: function( warehouse_id ){
  	// console.log("inside warehouse source");
  	// console.log(warehouse_id);
		var comboBox = this.down('form').getForm().findField('warehouse_from_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : warehouse_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( warehouse_id );
			}
		});
	},
	
	setSelectedWarehouseTarget: function( warehouse_id ){
		var comboBox = this.down('form').getForm().findField('warehouse_to_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : warehouse_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( warehouse_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		// console.log("i am inside setCOmboBox data from form.js warehouse mutation");
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouseSource( record.get("warehouse_from_id")  ) ;
		me.setSelectedWarehouseTarget( record.get("warehouse_to_id")  ) ;
	}
 
});



