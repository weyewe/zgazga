Ext.define('AM.controller.NeracaSaldos', {
  extend: 'Ext.app.Controller',

  stores: ['NeracaSaldos'],
  models: ['NeracaSaldo'],

  views: [
    'report.neracasaldo.List',
    'report.neracasaldo.Form' 
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'neracasaldolist'
		},
		{
			ref : 'searchField',
			selector: 'neracasaldolist textfield[name=searchField]'
		}
	],

  init: function() {
    this.control({
      'neracasaldolist': {
				afterrender : this.loadObjectList,
      },
      'neracasaldolist button[action=printObject]': {
        click: this.printObject
      },
      'neracasaldolist button[action=printPosNeracaObjectButton]': {
        click: this.printPosNeracaObjectButton
      },
       'neracasaldolist button[action=printIncomeStatementObjectButton]': {
        click: this.printIncomeStatementObjectButton
      },
	  	'neracasaldolist textfield[name=searchField]': {
        change: this.liveSearch
      },
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getNeracaSaldosStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getNeracaSaldosStore().load();
	},
	
	
	loadObjectList : function(me){
		// me.getStore().getProxy().extraParams = {}
		me.getStore().load();
	},

	printObject: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'neraca_saldos_' + 'download_report' + "?auth_token=" +auth_token_value+ ";closing_id=" + id);
			}
			
	},
	
	printPosNeracaObjectButton: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'neraca_saldos_' + 'download_posneraca_report' + "?auth_token=" +auth_token_value+ ";closing_id=" + id);
			}
			
	},
	
	printIncomeStatementObjectButton: function(){
			var record = this.getList().getSelectedObject();
			var id = record.get("id");
			var currentUser = Ext.decode( localStorage.getItem('currentUser'));
			var auth_token_value = currentUser['auth_token'];
			if( record ){
				window.open( 'neraca_saldos_' + 'download_income_statement_report' + "?auth_token=" +auth_token_value+ ";closing_id=" + id);
			}
			
	},
	
});
