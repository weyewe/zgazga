require 'rubyXL'


class ProfitLossStatement
    
    
    
    def self.create_header() 
        @worksheet.add_cell(0,1, "PT ZENTRUM GRAPHICS ASIA")
        @worksheet.add_cell(1,0, "Laba Rugi Bulan Berjalan")
        @worksheet.add_cell(1,1, @end_date ) 
    end
    
    def self.create_table_header
        @worksheet.add_cell(2,0, "Perkiraan")
        @worksheet.add_cell(2,1, "Dalam Rupiah" ) 
    end
    
    def self.populate_content
        @row = 3
        
        self.create_operational_profit  
        self.create_other_profit 
    end
    
    
    def self.create_operational_profit
        self.create_gross_profit
        self.create_operational_cost
        
        
        @worksheet.add_cell(@row, 1, "Laba Kotor" ) 
        @worksheet.add_cell(@row, 2, "xx" ) 
        
        @row = @row + 1 
    end
    
    def self.create_other_profit
        @worksheet.add_cell(@row, 1, "Pendapatan (Biaya) Lain-Lain" )
        @row = @row +1
        
        beban_lainnya = Account.find_by_code( "72" )
        total_beban_lainnya = BigDecimal('0')
        beban_lainnya.children.order("code ASC").each do |pendapatan_element|
            pendapatan_element.descendants.where(:is_ledger => true ).order("code ASC").each do |leaf_account|
                vc = ValidComb.where(:closing_id => @closing.id , :account_id => leaf_account.id ).first
            
                @worksheet.add_cell(@row, 1, leaf_account.name ) 
                @worksheet.add_cell(@row, 2, vc.amount  ) 
                
                total_beban_lainnya = total_beban_lainnya +  vc.amount  
            end
           
            
            @row = @row + 1 
            
        end
        
        pendapatan_lainnya = Account.find_by_code( "71" )
        total_pendapatan_lainnya = BigDecimal('0')
        pendapatan_lainnya.children.order("code ASC").each do |pendapatan_element|
            pendapatan_element.descendants.where(:is_ledger => true ).order("code ASC").each do |leaf_account|
                vc = ValidComb.where(:closing_id => @closing.id , :account_id => leaf_account.id ).first
            
                @worksheet.add_cell(@row, 1, leaf_account.name ) 
                @worksheet.add_cell(@row, 2, vc.amount  ) 
                
                total_pendapatan_lainnya = total_pendapatan_lainnya +  vc.amount  
            end
           
            
            @row = @row + 1 
            
        end
        @jumlah_pendapatan_lainnya = BigDecimal('0')
        @jumlah_pendapatan_lainnya = total_pendapatan_lainnya - total_beban_lainnya
        @worksheet.add_cell(@row, 1, "Jumlah Pendapatan Lain-Lain" ) 
        @worksheet.add_cell(@row, 2,   @jumlah_pendapatan_lainnya) 
            
    end
    
    def self.create_gross_profit
        
        pendapatan_group = Account.find_by_code( "41" )
        
        total_revenue = BigDecimal('0')
        
        pendapatan_group.children.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
            
            @worksheet.add_cell(@row, 1, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 2, vc.amount  ) 
            
            total_revenue = total_revenue +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 1, "Jumlah Pendapatan") 
        @worksheet.add_cell(@row, 2, total_revenue  ) 
        
        
        @row = @row + 2 
        
        @worksheet.add_cell(@row, 1, "HARGA POKOK PENJUALAN")  
        
        @row = @row + 2 
        
        cogs_group = Account.find_by_code( "51" )
        
        total_cogs = BigDecimal('0')
        
        cogs_group.children.order("code ASC").each do |cogs_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => cogs_element.id ).first
            
            @worksheet.add_cell(@row, 1, cogs_element.name ) 
            @worksheet.add_cell(@row, 2, vc.amount  ) 
            
            total_cogs = total_cogs +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 1, "Jumlah Harga Pokok Penjualan") 
        @worksheet.add_cell(@row, 2, total_cogs  )
        
        
        @row = @row +  1
        @gross_profit = total_revenue - total_cogs
        @worksheet.add_cell(@row, 1, "Laba Kotor") 
        @worksheet.add_cell(@row, 2, @gross_profit ) 
        
        @row = @row + 1 
        
        
    end
    
    
    def self.create_operational_cost
        @worksheet.add_cell(@row, 1, "Beban Operasional") 
        
        beban_penjualan = Account.find_by_code( "61" )
        
        total_beban_penjualan = BigDecimal('0')
        
        beban_penjualan.children.order("code ASC").each do |pendapatan_element|
            vc = ValidComb.where(:closing_id => @closing.id , :account_id => pendapatan_element.id ).first
            
            @worksheet.add_cell(@row, 1, pendapatan_element.name ) 
            @worksheet.add_cell(@row, 2, vc.amount  ) 
            
            total_beban_penjualan = total_beban_penjualan +  vc.amount  
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 1, "Jumlah Beban Penjualan") 
        @worksheet.add_cell(@row, 2, total_beban_penjualan  )
        
        @row = @row + 2 
        
        @worksheet.add_cell(@row, 1, "Beban Umum dan Administrasi") 
        
        beban_umum_group = Account.find_by_code( "62" )
        
        total_beban_umum = BigDecimal('0')
        
        beban_umum_group.children.order("code ASC").each do |pendapatan_element|
            pendapatan_element.descendants.where(:is_ledger => true ).order("code ASC").each do |leaf_account|
                vc = ValidComb.where(:closing_id => @closing.id , :account_id => leaf_account.id ).first
            
                @worksheet.add_cell(@row, 1, leaf_account.name ) 
                @worksheet.add_cell(@row, 2, vc.amount  ) 
                
                total_beban_umum = total_beban_umum +  vc.amount  
            end
           
            
            @row = @row + 1 
            
        end
        
        @worksheet.add_cell(@row, 1, "Jumlah Beban Umum dan Administrasi") 
        @worksheet.add_cell(@row, 2, total_beban_umum  )

        @row = @row + 2
        
        jumlah_beban_operasional = total_beban_penjualan + total_beban_umum
        @worksheet.add_cell(@row, 1, "Jumlah Beban Operasional") 
        @worksheet.add_cell(@row, 2,  jumlah_beban_operasional )

        @row = @row + 2
        @laba_operasional = @gross_profit - jumlah_beban_operasional
        @worksheet.add_cell(@row, 1, "Laba Operasional") 
        @worksheet.add_cell(@row, 2,  @laba_operasional )
        
        @row = @row + 2    
    end
    
    def self.create_report( filepath, start_date, end_date, closing  )
        @closing  = closing
        @start_date = start_date
        @end_date = end_date         
        @row = 0 


        @workbook = RubyXL::Workbook.new 
        
        @worksheet = @workbook[0]
        
        self.create_header
        
        self.create_table_header
        
        self.populate_content
        
        


        
        

        
        
         
        
         
        @workbook.write( filepath )
    end
end