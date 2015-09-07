
Ext.define('AM.view.operation.salesquotation.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesquotationform',

  title : 'Add / Edit SalesQuotation',
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
					xtype: 'textfield',
					fieldLabel : 'Nomor Surat',
					name : 'nomor_surat'
				},
				{
					xtype: 'textfield',
					fieldLabel : 'Nomor Versi',
					name : 'version_no'
				},
    		    {
    					xtype: 'datefield',
    					name : 'quotation_date',
    					fieldLabel: 'Tanggal Quotation',
    					format: 'Y-m-d',
    				},
    			{
        	        xtype: 'textarea',
        	        name : 'description',
        	        fieldLabel: 'Deskripsi'
    	      	},
    	      {
	    				fieldLabel: 'Contact',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'contact_name',
	    				valueField : 'contact_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreContact , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{contact_name}">' + 
	    												'<div class="combo-name">{contact_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {contact_description}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'contact_id' 
    	      			},
    	      	 {
    		        xtype: 'displayfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		  	  },
				 {
    		        xtype: 'displayfield',
    		        name : 'total_quote_amount',
    		        fieldLabel: 'Total Quote Amount'
    		  	  },
    		  	   {
    		        xtype: 'displayfield',
    		        name : 'total_rrp_amount',
    		        fieldLabel: 'Total RRP amount'
    		  	  },
    		  	   {
    		        xtype: 'displayfield',
    		        name : 'cost_saved',
    		        fieldLabel: 'Disc'
    		  	  },
    		  	  {
    		        xtype: 'displayfield',
    		        name : 'percentage_saved',
    		        fieldLabel: 'Disc (%)'
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
  
    setSelectedCustomer: function( contact_id ){
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
	
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedCustomer( record.get("contact_id")  ) ;
 
	}
 
});




