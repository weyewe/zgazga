
Ext.define('AM.view.operation.purchaserequestdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchaserequestdetailform',

  title : 'Add / Edit Memorial Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		var localJsonStoreBlanketType = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'category',
			fields	: [ 
				{ name : "category"}, 
				{ name : "category_text"}  
			], 
			data : [
				{ category : 1, category_text : "Penting & Mendesak"},
				{ category : 2, category_text : "Tidak Penting & Mendesak"},
				{ category : 3, category_text : "Penting & Tidak Mendesak"},
				{ category : 4, category_text : "Tidak Penting & Tidak Mendesak"},
			] 
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
	        name : 'purchase_request_id',
	        fieldLabel: 'purchase_request_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'purchase_request_code',
            fieldLabel: 'Kode PurchaseRequest'
        },
        {
    	        xtype: 'textfield',
    	        name : 'name',
    	        fieldLabel: 'Name'
    	     },
			{
    	        xtype: 'numberfield',
    	        name : 'amount',
    	        fieldLabel: 'Quantity'
    	     },
    	     {
    	        xtype: 'textfield',
    	        name : 'uom',
    	        fieldLabel: 'UoM'
    	     },
    	      {
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Deskripsi'
				},
				{
					fieldLabel: 'Category',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'category_text',
					valueField : 'category',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreBlanketType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{category_text}">' + 
													'<div class="combo-name">{category_text}</div>' +
							 					'</div>';
						}
					},
					name : 'category' 
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

	
	setComboBoxData : function( record){
		// var me = this; 
		// me.setLoading(true);
		
		
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('purchase_request_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('purchase_request_id').setValue(record.get('id'));
	}
 
});




