
Ext.define('AM.view.operation.virtualorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualorderdetailform',

  title : 'Add / Edit VirtualOrderDetail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
		storeId : 'item_search',
		fields	: [
		 		{
					name : 'item_sku',
					mapping : "sku"
				}, 
				{
					name : 'item_name',
					mapping : 'name'
				},
				{
					name : 'item_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_items',
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
	        name : 'virtual_order_id',
	        fieldLabel: 'virtual_order_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'virtual_order_code',
            fieldLabel: 'Kode VirtualOrder'
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
																'{item_sku}' 			+  
													 "</div>" +  
							 					'</div>';
						}
					},
					name : 'item_id' 
				},
				{
  	        xtype: 'numberfield',
  	        name : 'amount',
  	        fieldLabel: 'Quantity'
  	    },
				{
				  xtype: 'displayfield',
				  name : 'item_uom_name',
				  fieldLabel: 'UoM'
				},
				{
				  xtype: 'numberfield',
				  name : 'price',
				  fieldLabel: 'Value per item'
				}
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
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("item_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('virtual_order_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('virtual_order_id').setValue(record.get('id'));
	}
 
});




