require 'rubyXL'


class PayableMutation
    
    
    def self.create_report( filepath )
                
        
        workbook = RubyXL::Workbook.new 
        
        worksheet = workbook[0]
        
        
        worksheet.merge_cells(3, 0, 3, 10) 
        worksheet.merge_cells(4, 0, 4, 10) 
        worksheet.merge_cells(5, 0, 5, 10) 
        
        # Report Header
        worksheet.add_cell(3,0, "PT ZENTRUM GRAPHICS ASIA")
        worksheet.add_cell(4,0, "Account Payable Aging Schedule")
        worksheet.add_cell(5,0, "As of : 12 November 2014")
        
        
        worksheet.add_cell(7,0, "Vendor Id")
        worksheet.add_cell(7,1, "Vendor Name")
        worksheet.add_cell(7,2, "Currency")
        worksheet.add_cell(7,3, "Opening Balance")
        worksheet.add_cell(7,4, "Debet")
        worksheet.add_cell(7,5, "Credit")
        worksheet.add_cell(7,6, "Ending Balance")
        
        
        worksheet.add_cell(8,0, "")
        worksheet.add_cell(8,1, "PT Asian Bearindo")
        worksheet.add_cell(8,2, "IDR")
        worksheet.add_cell(8,3, "0")
        worksheet.add_cell(8,4, "0")
        worksheet.add_cell(8,5, "3096000")
        worksheet.add_cell(8,6, "3096000")
        
        worksheet.add_cell(9,0, "")
        worksheet.add_cell(9,1, "Carport")
        worksheet.add_cell(9,2, "IDR")
        worksheet.add_cell(9,3, "0")
        worksheet.add_cell(9,4, "504000")
        worksheet.add_cell(9,5, "504000")
        worksheet.add_cell(9,6, "0")
        
        
         
        
         
        workbook.write( filepath )
    end
end