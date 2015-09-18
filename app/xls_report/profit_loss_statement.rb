require 'rubyXL'


class ProfitLossStatement
    
    def self.create_report( filepath, closing  )
        @closing  = closing
        @start_date = closing.beginning_period
        @end_date = closing.end_date_period       
        @row = 0 


        @workbook = RubyXL::Workbook.new 
        
        @worksheet = @workbook[0]
        
        self.create_header
        
        self.create_table_header
        
        self.populate_content
        
        @workbook.write( filepath )
    end
    
    def self.create_header() 
        @worksheet.add_cell(0,0, "PT ZENTRUM GRAPHICS ASIA")
        @worksheet.add_cell(1,0, "Laba Rugi Bulan Berjalan")
        duration_string = "##{@end_date.month}-#{@end_date.year}"
        @worksheet.add_cell(1,1, duration_string ) 
    end
    
    def self.create_table_header
        @worksheet.add_cell(2,0, "Perkiraan")
        @worksheet.add_cell(2,1, "Dalam Rupiah" ) 
    end
    
    def self.populate_content
        @row = 3
        
        self.create_operational_profit  
        self.create_other_profit 
        
        @worksheet.add_cell(@row,0, "LABA BERSIH")
        laba_bersih = @laba_operasional - @jumlah_pendapatan_lainnya
        @worksheet.add_cell(@row,1, laba_bersih ) 
    end
    
    
    def self.create_operational_profit
        
        
        self.create_gross_profit
        self.create_operational_cost
        @row = @row + 1 
        
        
    end
    
    def self.create_other_profit
        @worksheet.add_cell(@row, 0, "Pendapatan (Biaya) Lain-Lain" )
        @row = @row + 1
        
        beban_lainnya = Account.find_by_code( "72" )
        total_beban_lainnya = BigDecimal('0')
        beban_lainnya.leaves.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
        
            @worksheet.add_cell(@row, 0, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 1, vc.amount  ) 
              
            total_beban_lainnya = total_beban_lainnya +  vc.amount  
            @row = @row + 1
            
        end
        
        pendapatan_lainnya = Account.find_by_code( "71" )
        total_pendapatan_lainnya = BigDecimal('0')
        pendapatan_lainnya.leaves.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
        
            @worksheet.add_cell(@row, 0, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 1, vc.amount  ) 
            
            total_pendapatan_lainnya = total_pendapatan_lainnya +  vc.amount  
            
            @row = @row + 1 
            
        end
        @jumlah_pendapatan_lainnya = BigDecimal('0')
        @jumlah_pendapatan_lainnya = total_pendapatan_lainnya - total_beban_lainnya
        @worksheet.add_cell(@row, 0, "Jumlah Pendapatan Lain-Lain" ) 
        @worksheet.add_cell(@row, 1,   @jumlah_pendapatan_lainnya) 
        
        @row = @row + 2   
    end
    
    def self.create_gross_profit
        
        pendapatan_group = Account.find_by_code( "41" )
        
        total_revenue = BigDecimal('0')
        
        pendapatan_group.leaves.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
            
            @worksheet.add_cell(@row, 0, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 1, vc.amount  ) 
            
            total_revenue = total_revenue +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 0, "Jumlah Pendapatan") 
        @worksheet.add_cell(@row, 1, total_revenue  ) 
        
        
        @row = @row + 2 
        
        @worksheet.add_cell(@row, 0, "HARGA POKOK PENJUALAN")  
        
        @row = @row + 2 
        
        cogs_group = Account.find_by_code( "51" )
        
        total_cogs = BigDecimal('0')
        
        cogs_group.leaves.order("code ASC").each do |cogs_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => cogs_element.id ).first
            
            @worksheet.add_cell(@row, 0, cogs_element.name ) 
            @worksheet.add_cell(@row, 1, vc.amount  ) 
            
            total_cogs = total_cogs +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 0, "Jumlah Harga Pokok Penjualan") 
        @worksheet.add_cell(@row, 1, total_cogs  )
        
        
        @row = @row +  1
        @gross_profit = total_revenue - total_cogs
        @worksheet.add_cell(@row, 0, "Laba Kotor") 
        @worksheet.add_cell(@row, 1, @gross_profit ) 
        
        @row = @row + 2 
    end
    
    
    def self.create_operational_cost
        @worksheet.add_cell(@row, 0, "Beban Operasional") 
        
        beban_penjualan = Account.find_by_code( "61" )
        
        total_beban_penjualan = BigDecimal('0')
        
        beban_penjualan.leaves.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
            
            @worksheet.add_cell(@row, 0, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 1, vc.amount  ) 
            
            total_beban_penjualan = total_beban_penjualan +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 0, "Jumlah Beban Penjualan") 
        @worksheet.add_cell(@row, 1, total_beban_penjualan  )
        
        @row = @row + 2 
        
        @worksheet.add_cell(@row, 0, "Beban Umum dan Administrasi") 
        
        @row = @row + 1 
        beban_umum_group = Account.find_by_code( "62" )
        
        total_beban_umum = BigDecimal('0')
        
        beban_umum_group.leaves.order("code ASC").each do |pendapatan_element|
                vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
            
                @worksheet.add_cell(@row, 0, pendapatan_element.name ) 
                @worksheet.add_cell(@row, 1, vc.amount  ) 
                
                total_beban_umum = total_beban_umum +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 0, "Jumlah Beban Umum dan Administrasi") 
        @worksheet.add_cell(@row, 1, total_beban_umum  )

        @row = @row + 2
        
        jumlah_beban_operasional = total_beban_penjualan + total_beban_umum
        @worksheet.add_cell(@row, 0, "Jumlah Beban Operasional") 
        @worksheet.add_cell(@row, 1,  jumlah_beban_operasional )

        @row = @row + 2
        @laba_operasional = @gross_profit - jumlah_beban_operasional
        @worksheet.add_cell(@row, 0, "Laba Operasional") 
        @worksheet.add_cell(@row, 1,  @laba_operasional )
        
        @row = @row + 2    
    end
    
    
end