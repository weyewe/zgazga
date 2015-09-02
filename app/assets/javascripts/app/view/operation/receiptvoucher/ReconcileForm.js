Ext.define('AM.view.operation.receiptvoucher.ReconcileForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.reconcilereceiptvoucherform',

  title : 'Reconcile',
  layout: 'fit',
	width	: 400,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
  	
		var localJsonStoreStatusPembulatan = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'status_pembulatan',
			fields	: [ 
				{ name : "status_pembulatan"}, 
				{ name : "status_pembulatan_text"}  
			], 
			data : [
				{ status_pembulatan : 1, status_pembulatan_text : "Debit"},
				{ status_pembulatan : 2, status_pembulatan_text : "Credit"},
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
					xtype: 'displayfield',
					fieldLabel: 'Kode',
					name: 'code' 
				},
			 
				{
					xtype: 'displayfield',
					fieldLabel: 'Tanggal Transaksi',
					name: 'receipt_date' 
				},
				{
					xtype: 'datefield',
					fieldLabel: 'Tanggal Reconcile',
					name: 'reconciliation_date' ,
					format: 'Y-m-d',
				},  
    		{				
					xtype: 'displayfield',
					fieldLabel : 'Total Amount',
					name : 'amount'
				},
		 
			]
    }];

    this.buttons = [{
      text: 'Confirm',
      action: 'confirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('code').setValue(record.get('code')); 
		this.down('form').getForm().findField('receipt_date').setValue(record.get('receipt_date')); 
		this.down('form').getForm().findField('amount').setValue(record.get('amount')); 
	}
});
