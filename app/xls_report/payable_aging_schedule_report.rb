class PayableAgingScheduleReport
    
    def self.create_report( filepath, start_date, end_date  )
      # @closing  = closing
      @start_date = start_date
      @end_date = end_date     
      @workbook = RubyXL::Workbook.new 
      @worksheet = @workbook[0]
      @row = 0
      self.create_header
  
      self.populate_content
      
      @workbook.write( filepath )
    end
    
    def self.create_header
      @worksheet.merge_cells(3, 0, 3, 12) 
      @worksheet.add_cell(3,0, "PT ZENTRUM GRAPHICS ASIA")
      @worksheet.merge_cells(4, 0, 4, 12) 
      @worksheet.add_cell(4,0, "Account Receivable Aging Schedule")
      @worksheet.merge_cells(6, 0, 6, 12) 
      duration_string = "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
      @worksheet.add_cell(6,0, "As Of : #{duration_string}")
      @row = 6 + 2
    end
      
    def self.populate_content
      
      
      grand_total_hash_week_1 = {}
      grand_total_hash_week_3 = {}
      grand_total_hash_week_4 = {}
      start_week_1 = 0
      start_week_3 = 0
      start_week_4 = 0
      end_week_1 = 0
      end_week_3 = 0
      end_week_4 = 0
      hash = {}
      Exchange.all.each do |exc|
        grand_total_hash_week_1[exc.id] = BigDecimal('0')
        grand_total_hash_week_3[exc.id] = BigDecimal('0')
        grand_total_hash_week_4[exc.id] = BigDecimal('0')
      end
      contact_id_list = Payable.where {
        ( is_completed.eq false) 
      }.select(:contact_id).uniq
      contact_list = Contact.where(:id => contact_id_list).order("name")
     
     
      
      contact_list.each do |contact|
        # Create header for each contact
        
        @worksheet.add_cell(@row, 0, contact.name  )  
        @row = @row + 1
        @worksheet.merge_cells(@row, 0, @row + 1, 0) 
        @worksheet.add_cell(@row, 0, "Invoice Date"  )
        @worksheet.merge_cells(@row, 1, @row + 1, 1) 
        @worksheet.add_cell(@row, 1, "Invoice Number"  )
        @worksheet.merge_cells(@row, 2, @row + 1, 2) 
        @worksheet.add_cell(@row, 2, "Received Date"  )
        @worksheet.merge_cells(@row, 3, @row + 1, 3) 
        @worksheet.add_cell(@row, 3, "Due Date"  )
        currency_amount = Exchange.count.to_i
        # weeks 1-2
        start_week_1 = 4
        end_week_1 = 4 + currency_amount
        @worksheet.merge_cells(@row, start_week_1, @row, end_week_1)
        # weeks 3-4
        start_week_3 = end_week_1 + 1
        end_week_3 = start_week_3 + currency_amount
        @worksheet.merge_cells(@row, start_week_3, @row, end_week_3)
        start_week_4 = end_week_3 + 1
        end_week_4 = start_week_4 +currency_amount
        # weeks 4 >
        @worksheet.merge_cells(@row, start_week_4, @row, end_week_4)
        @worksheet.add_cell(@row, start_week_1, "1 - 2 weeks"  )
        @worksheet.add_cell(@row, start_week_3, "3 - 4 weeks"  )
        @worksheet.add_cell(@row, start_week_4, "> 4 weeks"  )
        exchange_coordinate = []
        @row = @row + 1
        col = 0
        
        total_hash_week_1 = {}
        total_hash_week_3 = {}
        total_hash_week_4 = {}
        Exchange.all.each do |exc|
          @worksheet.add_cell(@row,col + start_week_1,exc.name)
          @worksheet.add_cell(@row,col + start_week_3,exc.name)
          @worksheet.add_cell(@row,col + start_week_4,exc.name)
          hash[exc.id] = col
          total_hash_week_1[exc.id] = BigDecimal('0')
          total_hash_week_3[exc.id] = BigDecimal('0')
          total_hash_week_4[exc.id] = BigDecimal('0')
          col = col + 1
        end
        @row = @row + 1
        Payable.where {
          ( is_completed.eq false) &
          ( contact_id.eq contact.id)
        }.each do |pyb|
          source_date = "#{pyb.source_date.day}-#{pyb.source_date.month}-#{pyb.source_date.year}"
          @worksheet.add_cell(@row,0,source_date)
          if not pyb.source.methods.include?("nomor_surat")
            @worksheet.add_cell(@row,1,pyb.source_code)
            else
            @worksheet.add_cell(@row,1,pyb.source.nomor_surat) 
          end
          confirmed_date = "#{pyb.source.confirmed_at.day}-#{pyb.source.confirmed_at.month}-#{pyb.source.confirmed_at.year}"
          @worksheet.add_cell(@row,2,confirmed_date) 
          due_date = "#{pyb.due_date.day}-#{pyb.due_date.month}-#{pyb.due_date.year}"
          @worksheet.add_cell(@row,3,due_date)
          date_range = (pyb.source_date.to_date - pyb.due_date.to_date).to_i
          if date_range <= 14 
            @worksheet.add_cell(@row, (start_week_1.to_i + hash[pyb.exchange_id].to_i),pyb.remaining_amount) 
            total_hash_week_1[pyb.exchange_id] += pyb.amount
            grand_total_hash_week_1[pyb.exchange_id] += pyb.amount
          elsif date_range.between?(15,28)
            @worksheet.add_cell(@row,(start_week_3.to_i + hash[pyb.exchange_id].to_i),pyb.remaining_amount) 
            total_hash_week_3[pyb.exchange_id] += pyb.amount
            grand_total_hash_week_3[pyb.exchange_id] += pyb.amount
          else
            @worksheet.add_cell(@row,(start_week_4.to_i + hash[pyb.exchange_id].to_i),pyb.remaining_amount) 
            total_hash_week_4[pyb.exchange_id] += pyb.amount
            grand_total_hash_week_4[pyb.exchange_id] += pyb.amount
          end 
          @row = @row + 1
        end
        Exchange.all.each do |exc|
          @worksheet.add_cell(@row,3,"Balance")
          @worksheet.add_cell(@row,start_week_1.to_i + hash[exc.id],total_hash_week_1[exc.id])
          @worksheet.add_cell(@row,start_week_3.to_i + hash[exc.id],total_hash_week_3[exc.id])
          @worksheet.add_cell(@row,start_week_4.to_i + hash[exc.id],total_hash_week_4[exc.id])
          col = col + 1
        end
         @row = @row + 3
        
      end
      Exchange.all.each do |exc|
        @worksheet.add_cell(@row,3,"Grand Total")
        @worksheet.add_cell(@row,start_week_1.to_i + hash[exc.id],grand_total_hash_week_1[exc.id])
        @worksheet.add_cell(@row,start_week_3.to_i + hash[exc.id],grand_total_hash_week_3[exc.id])
        @worksheet.add_cell(@row,start_week_4.to_i + hash[exc.id],grand_total_hash_week_4[exc.id])
      end
    end
    
    
    
end