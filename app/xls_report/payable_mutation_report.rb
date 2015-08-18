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
        @worksheet.add_cell(7,0, "Vendor Id")
        @worksheet.add_cell(7,1, "Vendor Name")
        @worksheet.add_cell(7,2, "Currency")
        @worksheet.add_cell(7,3, "Opening Balance")
        @worksheet.add_cell(7,4, "Debet")
        @worksheet.add_cell(7,5, "Credit")
        @worksheet.add_cell(7,6, "Ending Balance")
    end
    
    def self.populate_content
         
        row = 8 
        Contact.where(:contact_type => CONTACT_TYPE[:supplier].to_s).
                    joins(:payables => [:payment_voucher_details]).find_each do |supplier| 
                        
            
            zero_value = BigDecimal("0")
            opening_balance_query =   supplier.payables.where{
                (received_date.lt start_date) & 
                ( remaining_amount.not_eq zero_value ) 
            } 
            
            opening_balance_amount = opening_balance_query.sum("remaining_amount*exchange_rate_amount")
            
            
            additional_credit_query = supplier.payables.where{
                (received_date.gte start_date) & 
                (received_date.lt end_date) 
            }
            
            additional_credit =  additional_credit_query.sum("remaining_amount*exchange_rate_amount")
            
            possible_payables_id_list = supplier.payables.where{
                (
                    (received_date.lt start_date) & 
                    ( remaining_amount.not_eq zero_value ) 
                ) | 
                (
                    (received_date.gte start_date) & 
                     (received_date.lt end_date) 
                )
                
            }.map{|x| x.id } 
            
            payment = PaymentVoucherDetail.joins(:payment_voucher).where{
                ( payment_voucher.is_confirmed.eq true ) & 
                ( payment_date.gte start_date) & 
                ( payment_date.lt end_dat)
                
            }.sum
            
            
             
            @worksheet.add_cell(row,0, "")
            @worksheet.add_cell(row,1,  supplier.name )
            @worksheet.add_cell(row,2, "IDR")
            @worksheet.add_cell(row,3, "0")
            @worksheet.add_cell(row,4, "0")
            @worksheet.add_cell(row,5, "3096000")
            @worksheet.add_cell(row,6, "3096000") 
            
            row = row + 1 
        end
        
        # @worksheet.add_cell(8,0, "")
        # @worksheet.add_cell(8,1, "PT Asian Bearindo")
        # @worksheet.add_cell(8,2, "IDR")
        # @worksheet.add_cell(8,3, "0")
        # @worksheet.add_cell(8,4, "0")
        # @worksheet.add_cell(8,5, "3096000")
        # @worksheet.add_cell(8,6, "3096000")
        
        # @worksheet.add_cell(9,0, "")
        # @worksheet.add_cell(9,1, "Carport")
        # @worksheet.add_cell(9,2, "IDR")
        # @worksheet.add_cell(9,3, "0")
        # @worksheet.add_cell(9,4, "504000")
        # @worksheet.add_cell(9,5, "504000")
        # @worksheet.add_cell(9,6, "0")
    end
    
    def self.create_report( filepath, start_date, end_date )
        @start_date = start_date
        @end_date = end_date         
        
        @workbook = RubyXL::Workbook.new 
        
        @worksheet = @workbook[0]
        
        self.create_header
        
        self.create_table_header
        
        self.populate_content
        
        


        
        

        
        
         
        
         
        @workbook.write( filepath )
    end
end