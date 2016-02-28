class PurchaseOrderReport
    
  def self.create_report( filepath, start_date, end_date)
    @start_date = start_date
    @end_date = end_date    
    @row = 0 
    @workbook = RubyXL::Workbook.new 
    @worksheet = @workbook[0]
    
    self.create_header
    
    self.populate_content
    
    @workbook.write( filepath )
  end
  
  def self.create_header
    @worksheet.merge_cells(0, 0, 0, 15) 
    @worksheet.add_cell(0,0, "PT ZENTRUM GRAPHICS ASIA")
    @worksheet.merge_cells(1, 0, 1, 15) 
    @worksheet.add_cell(1,0, "Purchasing Report By Payment Due Date")
    @worksheet.merge_cells(2, 0, 2, 15) 
    end_duration_string = "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
    start_duration_string = "#{@start_date.day}-#{@start_date.month}-#{@start_date.year}"
    @worksheet.add_cell(2,0, "Periode : #{start_duration_string} sd #{end_duration_string}")
    
  end
  
  def self.populate_content
    self.populate_transaction_list
  end
  
  def self.populate_transaction_list
    start_date = @start_date
    end_date = @end_date
    @worksheet.add_cell(6,0, "No")
    @worksheet.add_cell(6,1, "Date")
    @worksheet.add_cell(6,2, "Supplier")
    @worksheet.add_cell(6,3, "PO Number")
    @worksheet.add_cell(6,4, "Item Description")
    @worksheet.add_cell(6,5, "Due Date")
    @worksheet.add_cell(6,6, "Sub Total")
    @worksheet.add_cell(6,7, "Retur")
    @worksheet.add_cell(6,8, "Payment")
    @worksheet.add_cell(6,9, "Balance")
    @row = 7
    transaction_list = PurchaseInvoiceDetail.joins(:purchase_invoice).where{
          ( purchase_invoices.due_date.gte start_date) & 
          ( purchase_invoices.due_date.lte end_date) 
    }.order("purchase_invoices.due_date")
  
    transaction_list.each do |tcl|
      no = 0
      transaction_date = "#{tcl.purchase_invoice.invoice_date.day}-#{tcl.purchase_invoice.invoice_date.month}-#{tcl.purchase_invoice.invoice_date.year}"
      @worksheet.add_cell(@row,0,no)
      @worksheet.add_cell(@row,1,transaction_date)
      @worksheet.add_cell(@row,2,tcl.purchase_invoice.purchase_receival.contact.name)
      @worksheet.add_cell(@row,3,tcl.purchase_receival_detail.purchase_order.nomor_surat)
      @worksheet.add_cell(@row,4,tcl.purchase_receival_detail.item.name)
      due_date = "#{tcl.purchase_invoice.due_date.day}-#{tcl.purchase_invoice.due_date.month}-#{tcl.purchase_invoice.due_date.year}"
      @worksheet.add_cell(@row,5,due_date)
      @worksheet.add_cell(@row,6,tcl.amount)
      @worksheet.add_cell(@row,7,0)
      @worksheet.add_cell(@row,8,0)
      @worksheet.add_cell(@row,9,tcl.amount)
      @worksheet[@row][6].set_number_format '#,###'
      @worksheet[@row][7].set_number_format '#,###'
      @worksheet[@row][8].set_number_format '#,###'
      @worksheet[@row][9].set_number_format '#,###'
      @row = @row + 1
      no = no + 1
    end
    @row = @row + 1
  end
  
end