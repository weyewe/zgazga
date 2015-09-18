class KartuBukuBesarReport
    
  def self.create_report( filepath, start_date, end_date ,account_id)
    @start_date = start_date
    @end_date = end_date    
    # @start_date = DateTime.now - 1.years
    # @end_date = DateTime.now         
    @account = Account.find_by_id(account_id)
    @account_id = @account_id
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
    @worksheet.add_cell(1,0, "KARTU BUKU BESAR")
    @worksheet.merge_cells(2, 0, 2, 15) 
    end_duration_string = "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
    start_duration_string = "#{@start_date.day}-#{@start_date.month}-#{@start_date.year}"
    @worksheet.add_cell(2,0, "Periode : #{start_duration_string} sd #{end_duration_string}")
    @worksheet.merge_cells(3, 0, 3, 15) 
    @worksheet.add_cell(3,0, "No.Perkiraan : [#{@account.code}]-#{@account.name}")
    
    # Sum saldo_awal
    start_date = @start_date
    end_date = @end_date
    acc_id = @account.id
    total_debit_awal = BigDecimal('0')
    total_credit_awal = BigDecimal('0')
    total_debit_akhir = BigDecimal('0')
    total_credit_akhir = BigDecimal('0')
    saldo_awal = BigDecimal('0')
    saldo_akhir = BigDecimal('0')
    total_debit_awal = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt start_date) & 
          ( account_id.eq acc_id) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
    total_credit_awal = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt start_date) & 
          ( account_id.eq acc_id) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
    
    if @account.normal_balance == NORMAL_BALANCE[:debit]
        saldo_awal = total_debit_awal - total_credit_awal
      else
        saldo_awal = total_credit_awal -  total_debit_awal
    end
    
    # Sum saldo_akhir
    total_debit_akhir = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_date) & 
          ( transaction_data.transaction_datetime.lte end_date) & 
          ( account_id.eq acc_id) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
    total_credit_akhir = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_date) & 
          ( transaction_data.transaction_datetime.lte end_date) & 
          ( account_id.eq acc_id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
    
    if @account.normal_balance == NORMAL_BALANCE[:debit]
        saldo_akhir = total_debit_akhir - total_credit_akhir
      else
        saldo_akhir = total_credit_akhir -  total_debit_akhir
    end
    
    saldo_akhir = saldo_awal + saldo_akhir
    @worksheet.add_cell(4,0, "SALDO AWAL :")
    @worksheet.add_cell(4,1, saldo_awal)
    @worksheet[4][1].set_number_format '#,###'
    @worksheet.add_cell(4,4, "SALDO AKHIR :")
    @worksheet.add_cell(4,5, saldo_akhir)
    @worksheet[4][5].set_number_format '#,###'
    @saldo = BigDecimal('0')
    @saldo = saldo_awal
  end
  
  def self.populate_content
    self.populate_transaction_list
  end
  
  def self.populate_transaction_list
    start_date = @start_date
    end_date = @end_date
    acc_id = @account.id
    @worksheet.add_cell(6,0, "Tanggal")
    @worksheet.add_cell(6,1, "Dokumen")
    @worksheet.add_cell(6,2, "No.Bukti")
    @worksheet.add_cell(6,3, "Keterangan")
    @worksheet.add_cell(6,4, "Mutasi Debet")
    @worksheet.add_cell(6,5, "Mutasi Kredit")
    @worksheet.add_cell(6,6, "Saldo")
    @row = 7
    transaction_list = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_date) & 
          ( transaction_data.transaction_datetime.lte end_date) & 
          ( account_id.eq acc_id)
    }.order("transaction_data.transaction_datetime")
    puts transaction_list.inspect
    @total_mutasi_debet = BigDecimal('0')
    @total_mutasi_kredit = BigDecimal('0')
    transaction_list.each do |tcl|
      transaction_date = "#{tcl.transaction_data.transaction_datetime.day}-#{tcl.transaction_data.transaction_datetime.month}-#{tcl.transaction_data.transaction_datetime.year}"
      @worksheet.add_cell(@row,0,transaction_date)
      @worksheet.add_cell(@row,1,tcl.transaction_data.transaction_source_type)
      @worksheet.add_cell(@row,3,tcl.transaction_data.description)
      if tcl.entry_case == NORMAL_BALANCE[:debit]
        @worksheet.add_cell(@row,4,tcl.amount)
        @worksheet[@row][4].set_number_format '#,###'
        @total_mutasi_debet = @total_mutasi_debet + tcl.amount
      else
        @worksheet.add_cell(@row,5,tcl.amount)
        @worksheet[@row][5].set_number_format '#,###'
        @total_mutasi_kredit = @total_mutasi_kredit + tcl.amount
      end
      if @account.normal_balance == NORMAL_BALANCE[:debit]
        if tcl.entry_case == NORMAL_BALANCE[:debit]
          @saldo = @saldo + tcl.amount
        else
          @saldo = @saldo - tcl.amount
        end
        @worksheet.add_cell(@row,6,@saldo)
      else
        if tcl.entry_case == NORMAL_BALANCE[:credit]
          @saldo = @saldo + tcl.amount
        else
          @saldo = @saldo - tcl.amount
        end 
        @worksheet.add_cell(@row,6,@saldo)
      end
      @worksheet[@row][6].set_number_format '#,###'
      @row = @row + 1
    end
    @row = @row + 1
    @worksheet.add_cell(@row,3,"JUMLAH")
    @worksheet.add_cell(@row,4,@total_mutasi_debet)
    @worksheet[@row][4].set_number_format '#,###'
    @worksheet.add_cell(@row,5,@total_mutasi_kredit)
    @worksheet[@row][5].set_number_format '#,###'
  end
  
end