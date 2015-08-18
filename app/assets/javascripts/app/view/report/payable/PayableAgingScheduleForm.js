
Ext.define('AM.view.report.payable.PayableAgingScheduleForm', {
  extend: 'Ext.form.Panel',
  alias : 'widget.payableagingscheduleform',
 

   title: 'AP Aging Schedule',
    bodyPadding: 5,
    width: 350,

    // The form will submit an AJAX request to this URL when submitted
    url: 'save-form.php',

    // Fields will be arranged vertically, stretched to full width
    layout: 'anchor',
    defaults: {
        anchor: '100%'
    },
    
 
    // The fields
    defaultType: 'textfield',
    items: [{
 
                
        xtype: 'datefield',
        name : 'report_date',
        fieldLabel: 'Tanggal Report',
        format: 'Y-m-d',
        allowBlank: false 
    }],

    // Reset and Submit buttons
    buttons: [{
        text: 'Reset',
        handler: function() {
            this.up('form').getForm().reset();
        }
    }, {
        text: 'Submit',
        formBind: true, //only enabled once the form is valid
        disabled: true,
        handler: function() {
            var form = this.up('form').getForm();
            console.log("The form");
            console.log( form  ); 
            
            var field = form.findField( 'report_date' ); 
            console.log("The field:");
            console.log( field );
            if (form.isValid()) {
                
                var el = form.getEl().dom;
                 var target = document.createAttribute("target");
                 target.nodeValue = "_blank";
                 el.setAttributeNode(target);
                 el.action = form.url;
                 el.submit(); 
                 
                 
                // form.submit({
                //     success: function(form, action) {
                //       Ext.Msg.alert('Success', action.result.msg);
                //     },
                //     failure: function(form, action) {
                //         Ext.Msg.alert('Failed', action.result.msg);
                //     }
                // });
            }
        }
    }]
 
});




