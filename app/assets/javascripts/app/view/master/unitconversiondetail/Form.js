
Ext.define('AM.view.master.unitconversiondetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.unitconversiondetailform',

  title : 'Add / Edit UnitConversion Detail',
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
					name : 'item_uom_name',
					mapping : "uom_name"
				} ,
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
	        name : 'unit_conversion_id',
	        fieldLabel: 'unit_conversion_id'
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
												'<div class="combo-name">{item_sku}</div>' + 
												'<div class="combo-name">Name: {item_name}</div>' + 
												'<div class="combo-name">QTY: {item_amount}</div>' + 
												'<div class="combo-name">UoM: {item_uom_name}</div>' + 
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
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("item_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('unit_conversion_id').setValue(record.get('id'));
	}
});




