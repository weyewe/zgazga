Ext.define('AM.view.operation.unitconversionorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.unitconversionorderform',

  title : 'Add / Edit UnitConversionOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
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
	
		var remoteJsonUnitConversion = Ext.create(Ext.data.JsonStore, {
			storeId : 'unit_conversion_search',
			fields	: [
	 				{
						name : 'unit_conversion_name',
						mapping : "name"
					},
					{
						name : 'unit_conversion_description',
						mapping : "description"
					},
					{
						name : 'unit_conversion_target_item_sku',
						mapping : "target_item_sku"
					},
					{
						name : 'unit_conversion_target_item_name',
						mapping : "target_item_name"
					},
					{
						name : 'unit_conversion_target_item_uom_name',
						mapping : "target_item_uom_name"
					},
					{
						name : 'unit_conversion_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_unit_conversions',
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
	      },{
	        xtype: 'textfield',
	        name : 'code',
	        fieldLabel: ' Code'
	      },
				{
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Deskripsi'
				},
				{
  				fieldLabel: 'Unit Convertion',
  				xtype: 'combo',
  				queryMode: 'remote',
  				forceSelection: true, 
  				displayField : 'unit_conversion_name',
  				valueField : 'unit_conversion_id',
  				pageSize : 5,
  				minChars : 1, 
  				allowBlank : false, 
  				triggerAction: 'all',
  				store : remoteJsonUnitConversion , 
  				listConfig : {
  					getInnerTpl: function(){
  						return  	'<div data-qtip="{unit_conversion_name}">' + 
  												'<div class="combo-name">{unit_conversion_name}</div>' + 
  												'<div class="combo-name">Deskripsi: {unit_conversion_description}</div>' + 
  												'<div class="combo-name">Target Sku: {unit_conversion_target_item_sku}</div>' + 
  												'<div class="combo-name">Target Name: {unit_conversion_target_item_sku}</div>' + 
  												'<div class="combo-name">UoM: {unit_conversion_target_item_uom_name}</div>' + 
  						 					'</div>';
  					}
  				},
  				name : 'unit_conversion_id' 
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
  					xtype: 'datefield',
  					name : 'conversion_date',
  					fieldLabel: 'Tanggal Convertion',
  					format: 'Y-m-d',
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


	
	setSelectedUnitConversion: function( unit_conversion_id ){
		var comboBox = this.down('form').getForm().findField('unit_conversion_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : unit_conversion_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( unit_conversion_id );
			}
		});
	},
	
  setSelectedWarehouse: function( warehouse_id ){
		var comboBox = this.down('form').getForm().findField('warehouse_id'); 
		var me = this; 
		var store = comboBox.store; 
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

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
		me.setSelectedUnitConversion( record.get("unit_conversion_id")  ) ;
 
	}
});

