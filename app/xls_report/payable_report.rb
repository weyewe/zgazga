require 'rubyXL'


class PayableReport
    
    def self.create_header()
        @worksheet.merge_cells(3, 0, 3, 10) 
        @worksheet.merge_cells(4, 0, 4, 10) 
        @worksheet.merge_cells(5, 0, 5, 10) 
        
        # Report Header
        @worksheet.add_cell(3,0, "PT ZENTRUM GRAPHICS ASIA")
        @worksheet.add_cell(4,0, "Account Payable")
        
        duration_string = "#{@start_date.day}-#{@start_date.month}-#{@start_date.year}"
        duration_string << "   -   "
        duration_string << "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
        
        @worksheet.add_cell(5,0,  duration_string)
    end
    
    def self.create_table_header
        
    end
    
    def self.populate_content
         
        row = 8 
        start_date = DateTime.now.beginning_of_month
        end_date = DateTime.now.end_of_month
        Exchange.all.each do |exc|
            super_grand_total_balance = BigDecimal('0')
            super_grand_total_debit = BigDecimal('0')
            super_grand_total_credit = BigDecimal('0') 
            contact_id_list = Payable.where {
                ( source_date.lte end_date) & 
                ( source_date.gte start_date) &
                ( exchange_id.eq exc.id)
             }.select(:contact_id).uniq
            contact_list = Contact.where(:id => contact_id_list).order("name")
      
            contact_list.each do |supplier| 
                
                @worksheet.add_cell(row,0, supplier.name)
                row = row + 1
                @worksheet.add_cell(row,0, "Invoice Date")
                @worksheet.add_cell(row,1, "Invoice Number")
                @worksheet.add_cell(row,2, "Received Date")
                @worksheet.add_cell(row,3, "Due Date")
                @worksheet.add_cell(row,4, "Ref No")
                @worksheet.add_cell(row,5, "Payment Date")
                @worksheet.add_cell(row,6, "Currency")
                @worksheet.add_cell(row,7, "Debet")
                @worksheet.add_cell(row,8, "Credit")
                @worksheet.add_cell(row,9, "Balance")
                row = row + 1
                
                
                grand_total_balance = BigDecimal('0')
                grand_total_debit = BigDecimal('0')
                grand_total_credit = BigDecimal('0')
                
                Payable.where{
                    ( source_date.lte end_date) & 
                    ( source_date.gte start_date) & 
                    ( contact_id.eq supplier.id ) &
                    ( exchange_id.eq exc.id)
                }.each do |pyb|
                    total_balance = BigDecimal('0')
                    total_credit = BigDecimal('0')
                    total_debit = BigDecimal('0')
                    source_date = "#{pyb.source_date.day}-#{pyb.source_date.month}-#{pyb.source_date.year}"
                    @worksheet.add_cell(row,0, source_date)
                    if not pyb.source.methods.include?(:nomor_surat)
                        @worksheet.add_cell(row,1,pyb.source_code)
                        else
                        @worksheet.add_cell(row,1,pyb.source.nomor_surat) 
                    end
                    confirmed_date = "#{pyb.source.confirmed_at.day}-#{pyb.source.confirmed_at.month}-#{pyb.source.confirmed_at.year}"
                    @worksheet.add_cell(row,2, confirmed_date)
                    due_date = "#{pyb.due_date.day}-#{pyb.due_date.month}-#{pyb.due_date.year}"
                    @worksheet.add_cell(row,3, due_date)
                    @worksheet.add_cell(row,6, exc.name)
                    @worksheet.add_cell(row,7, 0)
                    @worksheet.add_cell(row,8, pyb.amount)
                    @worksheet.add_cell(row,9, 0)
                    total_credit = total_credit + pyb.amount
                    row = row + 1
                    PaymentVoucherDetail.joins(:payment_voucher,:payable).where{
                        (payable.source_date.gte start_date) & 
                        (payable.source_date.lte end_date)  &
                        (payable.contact_id.eq supplier.id) &
                        (payment_voucher.is_confirmed.eq true) &
                        (payable.exchange_id.eq exc.id)
                        }.each do |pvd|
                        @worksheet.add_cell(row,0, source_date)
                        if not pyb.source.methods.include?(:nomor_surat)
                            @worksheet.add_cell(row,1,pyb.source_code)
                        else
                            @worksheet.add_cell(row,1,pyb.source.nomor_surat) 
                        end
                        confirmed_date = "#{pyb.source.confirmed_at.day}-#{pyb.source.confirmed_at.month}-#{pyb.source.confirmed_at.year}"
                        @worksheet.add_cell(row,2, confirmed_date)
                        due_date = "#{pyb.due_date.day}-#{pyb.due_date.month}-#{pyb.due_date.year}"
                        @worksheet.add_cell(row,3, due_date)
                        @worksheet.add_cell(row,4, pvd.payment_voucher.no_bukti)
                        payment_date = "#{pvd.payment_voucher.payment_date.day}-#{pvd.payment_voucher.payment_date.month}-#{pvd.payment_voucher.payment_date.year}"
                        @worksheet.add_cell(row,5, payment_date)
                        @worksheet.add_cell(row,6, exc.name)
                        @worksheet.add_cell(row,7, pvd.amount)
                        @worksheet.add_cell(row,8, 0)
                        @worksheet.add_cell(row,9, 0)  
                        total_debit = total_debit + pvd.amount
                        row = row + 1
                    end
                    if not pyb.source.methods.include?(:nomor_surat)
                        @worksheet.add_cell(row,2,"Balance For #{pyb.source_code}")
                    else
                        @worksheet.add_cell(row,2,"Balance For #{pyb.source.nomor_surat}") 
                    end    
                    total_balance = total_credit - total_debit
                    @worksheet.add_cell(row,6, exc.name)
                    @worksheet.add_cell(row,7, total_debit)
                    @worksheet.add_cell(row,8, total_credit)
                    @worksheet.add_cell(row,9, total_balance)  
                    grand_total_balance = grand_total_balance + total_balance
                    grand_total_credit = grand_total_credit + total_credit
                    grand_total_debit = grand_total_debit + total_debit
                    row = row + 2 
                end
                @worksheet.add_cell(row,2,"Balance For #{supplier.name}")
                @worksheet.add_cell(row,6, exc.name)
                @worksheet.add_cell(row,7, grand_total_debit)
                @worksheet.add_cell(row,8, grand_total_credit)
                @worksheet.add_cell(row,9, grand_total_balance)  
                super_grand_total_balance = super_grand_total_balance + grand_total_balance
                super_grand_total_debit = super_grand_total_debit + grand_total_debit
                super_grand_total_credit = super_grand_total_credit + grand_total_credit
                row = row + 2 
            end
            
            if contact_list.count > 0
                @worksheet.add_cell(row,2,"Grand Total")
                @worksheet.add_cell(row,6, exc.name)
                @worksheet.add_cell(row,7, super_grand_total_debit)
                @worksheet.add_cell(row,8, super_grand_total_credit)
                @worksheet.add_cell(row,9, super_grand_total_balance)  
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