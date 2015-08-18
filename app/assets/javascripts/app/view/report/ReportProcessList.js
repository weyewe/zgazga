Ext.define('AM.view.report.ReportProcessList', {
    extend: 'Ext.tree.Panel',
    alias: 'widget.reportProcessList',

    
    // title: 'Process List',
    rootVisible: false,
		cls: 'examples-list',
    lines: false,
    useArrows: true,

		store: 'Navigations'
});
