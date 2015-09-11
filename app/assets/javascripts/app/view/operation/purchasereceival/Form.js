
Ext.define('AM.view.operation.purchasereceival.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchasereceivalform',

  title : 'Add / Edit PurchaseReceival',
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
	
		var remoteJsonStoreExchange = Ext.create(Ext.data.JsonStore, {
		storeId : 'exchange_search',
		fields	: [
		 		{
					name : 'exchange_name',
					mapping : "name"
				} ,
				{
					name : 'exchange_description',
					mapping : "description"
				} ,
		 
				{
					name : 'exchange_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_exchanges',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	var remoteJsonStoreVendor = Ext.create(Ext.data.JsonStore, {
		storeId : 'vendor_search',
		fields	: [
		 		{
					name : 'vendor_name',
					mapping : "name"
				} ,
				{
					name : 'vendor_description',
					mapping : "description"
				} ,
		 
				{
					name : 'vendor_id',
					mapping : 'id'
				}  
			],
		
	 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_suppliers',
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
    					name : 'receival_date',
    					fieldLabel: 'Tanggal Penerimaan',
    					format: 'Y-m-d',
    			},
    			{
							xtype: 'textfield',
							fieldLabel : 'Nomor Surat',
							name : 'nomor_surat'
					},
    	        
    	    {
    				fieldLabel: 'Warehouse',
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
    				name : 'warehouse_id' 
    			},
    			
    			{
	    				fieldLabel: 'Contact',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'vendor_name',
	    				valueField : 'vendor_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreVendor , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{vendor_name}">' + 
	    												'<div class="combo-name">{vendor_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {vendor_description}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'contact_id' 
    	    	},
    	    		{
	    				fieldLabel: 'Currency',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'exchange_name',
	    				valueField : 'exchange_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreExchange , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{exchange_name}">' + 
	    												'<div class="combo-name">{exchange_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {exchange_description}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'exchange_id' 
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
  

  setSelectedWarehouse: function( warehouse_id ){
		var comboBox = this.down('form').getForm().findField('warehouse_id'); 
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
	
	setSelectedContact: function( contact_id ){
		var comboBox = this.down('form').getForm().findField('contact_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : contact_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( contact_id );
			}
		});
	},
	
	setExtraParamInPurchaseOrderIdComboBox: function(){  
		// var comboBox = this.down('form').getForm().findField('contact_id'); 
		// var store = comboBox.store;
		
		// store.getProxy().extraParams.purchase_receival =  true;
	},
	
	setComboBoxExtraParams: function( ) {  
		var me = this;
		me.setExtraParamInPurchaseOrderIdComboBox( ); 
	},
	
	
	setSelectedExchange: function( exchange_id ){
		var comboBox = this.down('form').getForm().findField('exchange_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : exchange_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( exchange_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
		me.setSelectedContact( record.get("contact_id")  ) ;
 		me.setSelectedExchange( record.get("exchange_id")  ) ;
	}
 
});




