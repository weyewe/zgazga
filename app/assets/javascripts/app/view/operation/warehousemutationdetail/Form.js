
Ext.define('AM.view.operation.warehousemutationdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.warehousemutationdetailform',

  title : 'Add / Edit Warehouse Mutation Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	

	var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
		storeId : 'warehouse_item_search',
		fields	: [
		 		{
					name : 'item_sku',
					mapping : "item_sku"
				}, 
				{
					name : 'item_name',
					mapping : 'item_name'
				},
				{
					name : 'amount',
					mapping : 'amount'
				},
				{
					name : 'item_id',
					mapping : "item_id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_warehouse_stock_details',
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
	        xtype: 'hidden',
	        name : 'warehouse_mutation_id',
	        fieldLabel: 'warehouse_mutation_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'warehouse_mutation_code',
            fieldLabel: 'Kode WarehouseMutation'
        },
			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'item_name',
				valueField : 'item_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreItem , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{item_name}">' +  
												'<div class="combo-name">'  + 
															" ({item_name}) " 		+ "<br />" 	 + 
															'{item_sku}' 				+ "<br />" 	 + 
															'QTY warehouse from : {amount}' 				+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'item_id' 
			},
				
			{
    	        xtype: 'textfield',
    	        name : 'amount',
    	        fieldLabel: 'Quantity'
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

	setSelectedItem: function( item_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('item_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( item_id );
			}
		});
	},
	
	setExtraParamInItemComboBox: function(id){
		var comboBox = this.down('form').getForm().findField('item_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.warehouse_id =  id;
	},
	
	
	setComboBoxExtraParams: function( record ) { 
		
		console.log( record ) ;
		var me =this;
		me.setExtraParamInItemComboBox( record.get("id") ); 
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("item_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('warehouse_mutation_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('warehouse_mutation_id').setValue(record.get('id'));
	}
 
});




