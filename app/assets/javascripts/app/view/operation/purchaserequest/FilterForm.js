
Ext.define('AM.view.operation.purchaserequest.FilterForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.filterpurchaserequestform',

  title : 'Filter PurchaseRequest',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 

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
    					xtype: 'checkboxfield',
    					name : 'is_confirmed',
    					fieldLabel: 'Sudah Konfirmasi?' 
				},
                {
    					xtype: 'datefield',
    					name : 'start_confirmation',
    					fieldLabel: 'Mulai Konfirmasi',
    					format: 'Y-m-d',
				},
				
                {
    					xtype: 'datefield',
    					name : 'end_confirmation',
    					fieldLabel: 'Akhir Konfirmasi',
    					format: 'Y-m-d',
				},
 
 
    		    {
    					xtype: 'datefield',
    					name : 'start_request_date',
    					fieldLabel: 'Mulai Request',
    					format: 'Y-m-d',
    			},
    			{
    					xtype: 'datefield',
    					name : 'end_request_date',
    					fieldLabel: 'Akhir Request',
    					format: 'Y-m-d',
    			}, 
    	 
			]
    }];
    
    
    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Reset',
      action: 'reset'
    },{
      text: 'Cancel',
      scope: this,
      handler: this.close
    },
    ];

    this.callParent(arguments);
  },
   
	setPreviousValue: function(extraParamsObject){
	   // console.log("inside setting the previous value");
	    var me = this; 
	    var view = this; 
 
 		var form_new  = view.down('form');
  
 		var items = form_new.items ; 
 		me.setLoading(true);
     		
       for(i = 0; i <  items.length; i += 1){ 
             var item_i = items.getAt(i);
             
             
             var field  = view.down('form').getForm().findField( item_i.name ); 
             
             if( item_i.name in extraParamsObject ){
                 
             }else{
                  
                 continue; 
             }
             
             
             var field_value = extraParamsObject[item_i.name]  
             var field_name = item_i.name
             
          
             
             if( item_i.xtype !== "combo"){ 
             	field.setValue( field_value) ;
             	
             	
             }else{
   
   
   
        		var comboBox = field;  
        		var me = this; 
        		var store = comboBox.store;   
                // console.log("gonna remote load "+ field_name);
                
                me.loadComboBox( comboBox, field_value, field_name );
  
             } 
        }
        me.setLoading(false);
        
	},
	
	loadComboBox: function(comboBox, field_value, field_name ){
        		var store = comboBox.store;  
                // console.log("gonna remote load "+ field_name);
 

        		store.load({
        			params: {
        				selected_id :  field_value
        			},
        			callback : function(records, options, success){
        				// console.log("success remote load "+ field_name);
        				comboBox.setValue( field_value );
        			}
        		});
	    
	}
 
});


