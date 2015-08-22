require 'rubyXL'


class VendorPaymentReport
    
    def self.create_header()
        @worksheet.merge_cells(3, 0, 3, 10) 
        @worksheet.merge_cells(4, 0, 4, 10) 
        @worksheet.merge_cells(5, 0, 5, 10) 
        
        # Report Header
        @worksheet.add_cell(3,0, "PT ZENTRUM GRAPHICS ASIA")
        @worksheet.add_cell(4,0, "Vendor Payment")
        
        duration_string = "#{@start_date.day}-#{@start_date.month}-#{@start_date.year}"
        duration_string << "   -   "
        duration_string << "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
        
        @worksheet.add_cell(5,0,  duration_string)
    end
    
    def self.create_table_header
        
    end
    
    def self.populate_content
         
        row = 6 
        start_date = DateTime.now.beginning_of_month
        end_date = DateTime.now.end_of_month
       
        Exchange.all.each do |exc|
            total_amount = BigDecimal('0')
           
            payment_voucher_query = PaymentVoucherDetail.joins(:payment_voucher,:payable).where{
                        (payable.source_date.gte start_date) & 
                        (payable.source_date.lte end_date)  &
                        (payment_voucher.is_confirmed.eq true) &
                        (payable.exchange_id.eq exc.id)
                        }
            if payment_voucher_query.count > 0 
                @worksheet.add_cell(row,0, "Date")
                @worksheet.add_cell(row,1, "Ref No")
                @worksheet.add_cell(row,2, "Vendor Name")
                @worksheet.add_cell(row,3, "Invoice Date")
                @worksheet.add_cell(row,4, "Invoice Number")
                @worksheet.add_cell(row,5, "Currency")
                @worksheet.add_cell(row,6, "Discount")
                @worksheet.add_cell(row,7, "Payment")
                row = row + 1
            end
            payment_voucher_query.each do |pvd|
               
                payment_date = "#{pvd.payment_voucher.payment_date.day}-#{pvd.payment_voucher.payment_date.month}-#{pvd.payment_voucher.payment_date.year}"
                @worksheet.add_cell(row,0, payment_date)
                @worksheet.add_cell(row,1, pvd.payment_voucher.no_bukti)
                @worksheet.add_cell(row,2, pvd.payment_voucher.contact.name)
                source_date = "#{pvd.payable.source_date.day}-#{pvd.payable.source_date.month}-#{pvd.payable.source_date.year}"
                @worksheet.add_cell(row,3, source_date)
                if not pvd.payable.source.methods.include?("nomor_surat")
                    @worksheet.add_cell(row,4,pvd.payable.source_code)
                else
                    @worksheet.add_cell(row,4,pvd.payable.source.nomor_surat) 
                end
                @worksheet.add_cell(row,5,exc.name)                 
                @worksheet.add_cell(row,7,pvd.amount)                 
                total_amount = total_amount + pvd.amount
                row = row + 1
            end
            if payment_voucher_query.count > 0 
                row = row + 1
                @worksheet.add_cell(row,4,"Total Payment")                 
                @worksheet.add_cell(row,5,exc.name)                 
                @worksheet.add_cell(row,7,total_amount)  
                row = row + 2
            end
        end
        
        
    end
    
    def self.create_report( filepath, start_date, end_date )
        @start_date = DateTime.now.beginning_of_month 
        @end_date = DateTime.now.end_of_month      
        
        @workbook = RubyXL::Workbook.new 
        
        @worksheet = @workbook[0]
        
        self.create_header
        
        self.create_table_header
        
        self.populate_content
        
        @workbook.write( filepath )
    end
end