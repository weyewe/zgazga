require 'rubyXL'


class PayableMutationReport
    
    def self.create_header()
        @worksheet.merge_cells(3, 0, 3, 10) 
        @worksheet.merge_cells(4, 0, 4, 10) 
        @worksheet.merge_cells(5, 0, 5, 10) 
        
        # Report Header
        @worksheet.add_cell(3,0, "PT ZENTRUM GRAPHICS ASIA")
        @worksheet.add_cell(4,0, "Account Payable Aging Schedule")
        
        duration_string = "#{@start_date.day}-#{@start_date.month}-#{@start_date.year}"
        duration_string << "   -   "
        duration_string << "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
        
        @worksheet.add_cell(5,0,  duration_string)
    end
    
    def self.create_table_header
        
    end
    
    def self.populate_content
         
        row = 8 
        
        Exchange.all.each do |exc|
            @worksheet.add_cell(row,0, "Vendor Id")
            @worksheet.add_cell(row,1, "Vendor Name")
            @worksheet.add_cell(row,2, "Currency")
            @worksheet.add_cell(row,3, "Opening Balance")
            @worksheet.add_cell(row,4, "Debet")
            @worksheet.add_cell(row,5, "Credit")
            @worksheet.add_cell(row,6, "Ending Balance")
            row = row + 1
            total_opening = BigDecimal('0')
            total_ending = BigDecimal('0')
            total_debit = BigDecimal('0')
            total_credit = BigDecimal('0')
            Contact.all.each do |supplier| 
                
                start_date = DateTime.now.beginning_of_month
                end_date = DateTime.now.end_of_month
                opening_balance_query = Payable.where{
                    ( source_date.lt start_date) & 
                    ( remaining_amount.not_eq 0 ) &
                    ( contact_id.eq supplier.id ) &
                    ( exchange_id.eq exc.id)
                } 
                
                opening_balance_amount = opening_balance_query.sum("remaining_amount")
                total_opening = total_opening + opening_balance_amount
                
                additional_credit_query = PaymentVoucherDetail.joins(:payment_voucher,:payable).where{
                    (payable.source_date.gte start_date) & 
                    (payable.source_date.lt end_date)  &
                    (payable.contact_id.eq supplier.id) &
                    (payment_voucher.is_confirmed.eq true) &
                    (payable.exchange_id.eq exc.id)
                }
                
                additional_credit_amount =  additional_credit_query.sum("amount")
                total_credit = total_credit + additional_credit_amount
                
                additional_debit_query = Payable.where{
                    ( source_date.gte start_date) & 
                    ( source_date.lt end_date) & 
                    ( contact_id.eq supplier.id ) &
                    ( exchange_id.eq exc.id)
                } 
                
                additional_debit_amount =  additional_debit_query.sum("amount")
                total_debit = total_debit + additional_debit_amount
                
                ending_balance_amount = opening_balance_amount + additional_debit_amount - additional_credit_amount
                total_ending = total_ending + ending_balance_amount
                
                @worksheet.add_cell(row,0, supplier.id)
                @worksheet.add_cell(row,1, supplier.name )
                @worksheet.add_cell(row,2, exc.name)
                @worksheet.add_cell(row,3, opening_balance_amount)
                @worksheet.add_cell(row,4, additional_debit_amount)
                @worksheet.add_cell(row,5, additional_credit_amount)
                @worksheet.add_cell(row,6, ending_balance_amount) 
                
                row = row + 1 
            end
            @worksheet.add_cell(row,0, "Total :")
            @worksheet.add_cell(row,2, exc.name)
            @worksheet.add_cell(row,3, total_opening)
            @worksheet.add_cell(row,4, total_debit)
            @worksheet.add_cell(row,5, total_credit)
            @worksheet.add_cell(row,6, total_ending) 
            row = row + 2
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