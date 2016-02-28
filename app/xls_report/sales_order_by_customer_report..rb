class SalesOrderReport
    
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
    @worksheet.add_cell(1,0, "Sales Order Daily")
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
    @worksheet.add_cell(6,0, "Tanggal")
    @worksheet.add_cell(6,1, "Item Sku")
    @worksheet.add_cell(6,2, "Item Description")
    @worksheet.add_cell(6,3, "Customer Name")
    @worksheet.add_cell(6,4, "QTY")
    @worksheet.add_cell(6,5, "Price List")
    @worksheet.add_cell(6,6, "Currency")
    # @worksheet.add_cell(6,7, "Rate")
    # @worksheet.add_cell(6,8, "Discount")
    @worksheet.add_cell(6,7, "Base Amt.")
    @worksheet.add_cell(6,8, "Total QTY Shipped")
    @worksheet.add_cell(6,9, "Order")
    @row = 7
    transaction_list = SalesOrderDetail.joins(:sales_order).where{
          ( sales_orders.sales_date.gte start_date) & 
          ( sales_orders.sales_date.lte end_date) 
    }.order("sales_orders.sales_date")
  
    transaction_list.each do |tcl|
      transaction_date = "#{tcl.sales_order.sales_date.day}-#{tcl.sales_order.sales_date.month}-#{tcl.sales_order.sales_date.year}"
      @worksheet.add_cell(@row,0,transaction_date)
      @worksheet.add_cell(@row,1,tcl.item.sku)
      @worksheet.add_cell(@row,2,tcl.item.name)
      @worksheet.add_cell(@row,3,tcl.sales_order.contact.name)
      @worksheet.add_cell(@row,4,tcl.amount)
      @worksheet.add_cell(@row,5,tcl.price)
      @worksheet.add_cell(@row,6,tcl.sales_order.exchange.name)
      @worksheet.add_cell(@row,7,tcl.price * tcl.amount)
      @worksheet.add_cell(@row,8,tcl.amount - tcl.pending_delivery_amount)
      @worksheet.add_cell(@row,9,tcl.is_all_delivered)
      @worksheet[@row][5].set_number_format '#,###'
      @worksheet[@row][6].set_number_format '#,###'
      @worksheet[@row][7].set_number_format '#,###'
      @worksheet[@row][8].set_number_format '#,###'
      @row = @row + 1
    end
    @row = @row + 1
  end
  
end