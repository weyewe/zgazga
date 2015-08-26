
Ext.define('AM.view.operation.virtualorderclearancedetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualorderclearancedetailform',

  title : 'Add / Edit VirtualOrderClearance Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
	var remoteJsonStoreVirtualDeliveryOrderDetail = Ext.create(Ext.data.JsonStore, {
		storeId : 'virtual_delivery_order_search',
		fields	: [
		 		{
					name : 'virtual_delivery_order_detail_code' ,
					mapping : "code"
				}, 
				{
					name : 'virtual_order_detail_item_sku',
					mapping : 'virtual_order_detail_item_sku'
				},
				{
					name : 'virtual_order_detail_item_name',
					mapping : 'virtual_order_detail_item_name'
				},
				{
					name : 'virtual_delivery_order_detail_amount',
					mapping : 'amount'
				},
				{
					name : 'virtual_delivery_order_detail_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_virtual_delivery_order_details',
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
	        name : 'virtual_order_clearance_id',
	        fieldLabel: 'virtual_order_clearance_id'
	      },
	      {
          xtype: 'displayfield',
          name : 'virtual_order_clearance_code',
          fieldLabel: 'Kode VirtualOrderClearance'
        },
				{
					fieldLabel: 'Delivery VirtualOrder Detail',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'virtual_delivery_order_detail_code',
					valueField : 'virtual_delivery_order_detail_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreVirtualDeliveryOrderDetail , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{virtual_delivery_order_detail_code}">' +  
													'<div class="combo-name">{virtual_delivery_order_detail_id}</div>' +  
													'<div class="combo-name">Item Sku : {virtual_order_detail_item_sku}</div>' +  
													'<div class="combo-name">Item Name : {virtual_order_detail_item_name}</div>' +  
													'<div class="combo-name">Amount : {virtual_delivery_order_detail_amount}</div>' +  
							 					'</div>';
						}
					},
					name : 'virtual_delivery_order_detail_id' 
				},
				{
	        xtype: 'numberfield',
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

	setSelectedVirtualDeliveryOrderDetail: function( virtual_delivery_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('virtual_delivery_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : virtual_delivery_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( virtual_delivery_order_detail_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedVirtualDeliveryOrderDetail( record.get("virtual_delivery_order_detail_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('virtual_order_clearance_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('virtual_order_clearance_id').setValue(record.get('id'));
	}
 
});




