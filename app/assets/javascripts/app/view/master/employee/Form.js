Ext.define('AM.view.master.employee.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.employeeform',

  title : 'Add / Edit Employee',
  layout: 'fit',
	width	: 960, 
  autoShow: true,  // does it need to be called?
	modal : true, 
	height : 500,
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	employeeInfo : function(){
				var entityInfo = {
					xtype : 'fieldset',
					title : "Info Pegawai",
					flex : 1 , 
					border : true, 
					labelWidth: 60,
					defaultType : 'field',
					width : '90%',
					defaults : {
						anchor : '-10'
					},
					items : [
						{
							xtype: 'hidden',
							fieldLabel: 'id',
							name: 'id' 
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Name Pegawai',
							name : 'name'
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Contact No',
							name : 'contact_no' 
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Email',
							name : 'email' 
						},
						{
							xtype: 'textarea',
							fieldLabel : 'Alamat',
							name : 'address' 
						}, 
						{
							xtype: 'textarea',
							fieldLabel : 'Deskripsi',
							name : 'description' 
						}, 
						
	
					]
				};
				
				
				
			 
				
				var container = {
					xtype : 'container',
					layoutConfig: {
						align :'stretch'
					},
					flex: 1, 
					width : 500,
					layout : 'vbox',
					items : [
						entityInfo 
					]
				};
				
				return container; 
	},
	
	
	
  initComponent: function() {
	
	
    			
		var me = this; 
    			
	    this.items = [{
	      xtype: 'form',
				msgTarget	: 'side',
				border: false,
	      bodyPadding: 10,
				fieldDefaults: {
	          labelWidth: 100,
						anchor: '100%'
	      },
				height : 350,
				overflowY : 'auto', 
				layout : 'hbox', 
				// height : 400,
				items : [
					me.employeeInfo(), 
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

	setSelectedContactGroup: function( contact_group_id ){
		
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		// me.setSelectedContactGroup( record.get("contact_group_id")  ) ;
	}
});

