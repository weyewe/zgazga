Ext.define('AM.view.operation.closing.UnconfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unconfirmclosingform',

  title : 'Reopen',
  layout: 'fit',
	width	: 400,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
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
					xtype: 'displayfield',
					fieldLabel: 'ID',
					name: 'id' 
				},
			 
			]
    }];

    this.buttons = [{
      text: 'Unconfirm',
      action: 'confirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('id').setValue(record.get('id')); 
	}
});
