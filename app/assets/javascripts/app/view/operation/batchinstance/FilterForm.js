
Ext.define('AM.view.operation.batchinstance.FilterForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.filterbatchinstanceform',

  title : 'Filter BatchInstance',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	var me = this; 
	
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
    					xtype: 'checkboxfield',
    					name : 'is_min_amount',
    					fieldLabel: 'Cari Jumlah Min?' 
				},
                {
    					xtype: 'numberfield',
    					name : 'min_amount',
    					fieldLabel: 'Jumlah Minimum' 
				},
				
              
 
    		    {
    					xtype: 'datefield',
    					name : 'start_manufactured_at',
    					fieldLabel: 'Mulai Tanggal Manufaktur',
    					format: 'Y-m-d',
				},
 
    		    {
    					xtype: 'datefield',
    					name : 'end_manufactured_at',
    					fieldLabel: 'Akhir Tanggal Manufaktur',
    					format: 'Y-m-d',
				},

		 
			
				{
    				fieldLabel: 'Item',
    				xtype: 'combo',
    				queryMode: 'remote',
    				forceSelection: false, 
    				displayField : 'item_sku',
    				valueField : 'item_id',
    				pageSize : 5,
    				minChars : 1, 
    				allowBlank : true, 
    				triggerAction: 'all',
    				store : remoteJsonStoreItem , 
    				listConfig : {
    					getInnerTpl: function(){
    						return  	'<div data-qtip="{item_sku}">' + 
    												'<div class="combo-name">{item_sku}</div>' + 
    												'<div class="combo-name">Deskripsi: {item_name}</div>' + 
    						 					'</div>';
    					}
					},
					name : 'item_id' 
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












