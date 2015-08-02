
Ext.define('AM.view.operation.recoveryresult.FilterForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.filterrecoveryresultform',

  title : 'Filter RecoveryResult',
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
	
	var remoteJsonStoreRollerIdentificationForm = Ext.create(Ext.data.JsonStore, {
		storeId : 'roller_identification_form_search',
		fields	: [
		 		{
					name : 'roller_identification_form_code',
					mapping : "code"
				} ,
				{
					name : 'roller_identification_nomor_disasembly',
					mapping : "nomor_disasembly"
				} ,
		 
				{
					name : 'roller_identification_form_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_roller_identification_forms',
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
    					xtype: 'checkboxfield',
    					name : 'is_finished',
    					fieldLabel: 'Finish?' 
				},
                {
    					xtype: 'datefield',
    					name : 'start_finished_date',
    					fieldLabel: 'Mulai Finish',
    					format: 'Y-m-d',
				},
				
                {
    					xtype: 'datefield',
    					name : 'end_finished_date',
    					fieldLabel: 'Akhir Finish',
    					format: 'Y-m-d',
				},
				
				
				{
    					xtype: 'checkboxfield',
    					name : 'is_rejected',
    					fieldLabel: 'Reject?' 
				},
                {
    					xtype: 'datefield',
    					name : 'start_rejected_date',
    					fieldLabel: 'Mulai Reject',
    					format: 'Y-m-d',
				},
				
                {
    					xtype: 'datefield',
    					name : 'end_rejected_date',
    					fieldLabel: 'Akhir Reject',
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


