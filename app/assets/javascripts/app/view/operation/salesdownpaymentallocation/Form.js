
Ext.define('AM.view.operation.salesdownpaymentallocation.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesdownpaymentallocationform',

  title : 'Add / Edit SalesDownPaymentAllocation',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreContact = Ext.create(Ext.data.JsonStore, {
		storeId : 'contact_search',
		fields	: [
		 		{
					name : 'contact_name',
					mapping : "name"
				} ,
				{
					name : 'contact_description',
					mapping : "description"
				} ,
		 
				{
					name : 'contact_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_customers',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	
	var remoteJsonStoreSalesDownPayment = Ext.create(Ext.data.JsonStore, {
		storeId : 'sales_down_payment_search',
		fields	: [
		 		{
					name : 'sales_down_payment_code',
					mapping : "code"
				} ,
				{
					name : 'sales_down_payment_contact_name',
					mapping : "contact_name"
				} ,
				{
					name : 'sales_down_payment_payable_source_code',
					mapping : "payable_source_code"
				} ,
				{
					name : 'sales_down_payment_exchange_name',
					mapping : "exchange_name"
				} ,
		 		{
					name : 'sales_down_payment_payable_total_amount',
					mapping : "total_amount"
				} ,
				{
					name : 'sales_down_payment_payable_remaining_amount',
					mapping : "payable_remaining_amount"
				} ,
				{
					name : 'sales_down_payment_payable_id',
					mapping : "payable_id"
				} ,
				{
					name : 'sales_down_payment_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_sales_down_payments',
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
    					name : 'allocation_date',
    					fieldLabel: 'Tanggal Alokasi',
    					format: 'Y-m-d',
    				},
    				{
	    				fieldLabel: 'DownPayment',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'sales_down_payment_code',
	    				valueField : 'sales_down_payment_payable_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreSalesDownPayment , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{sales_down_payment_code}">' + 
	    												'<div class="combo-name">{sales_down_payment_code}</div>' + 
	    												'<div class="combo-name">Contact: {sales_down_payment_contact_name}</div>' + 
	    												'<div class="combo-name">Source: {sales_down_payment_payable_source_code}</div>' + 
	    												'<div class="combo-name">Total: {sales_down_payment_payable_total_amount}</div>' + 
	    												'<div class="combo-name">Remaining: {sales_down_payment_payable_remaining_amount}</div>' + 
	    												'<div class="combo-name">Currency: {sales_down_payment_exchange_name}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'payable_id' 
    				},
    				 {
    		        xtype: 'numberfield',
    		        name : 'rate_to_idr',
    		        fieldLabel: 'Rate to IDR'
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
  
	
	setSelectedPayable: function( payable_id ){
		var comboBox = this.down('form').getForm().findField('payable_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : payable_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( payable_id );
			}
		});
	},
	
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedPayable( record.get("payable_id")  ) ;
 
	}
 
});




