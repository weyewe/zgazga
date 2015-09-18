class PosNeracaReport
    
  def self.create_report( filepath ,closing )
    @closing  = closing
    @start_date = closing.beginning_period
    @end_date = closing.end_date_period
    @date = closing.end_date_period
    @row = 0 
    @workbook = RubyXL::Workbook.new 
    @worksheet = @workbook[0]
    
    self.create_header
    
    self.populate_content
    
    @workbook.write( filepath )
  end
  
  def self.create_header
    # @worksheet.merge_cells(0, 1, 0, 15) 
    @worksheet.add_cell(0,1, "PT ZENTRUM GRAPHICS ASIA")
    # @worksheet.merge_cells(1, 1, 1, 15) 
    @worksheet.add_cell(1,1, "PERINCIAN POS POS NERACA")
    # @worksheet.merge_cells(2, 1, 1, 15) 
    duration_string = "#{@date.day}-#{@date.month}-#{@date.year}"
    @worksheet.add_cell(2,1, "Per #{duration_string}")
    @worksheet.add_cell(4,1, "Unit : RP.")
    @row = 6
  end
  
  def self.populate_content
    self.populate_kas_dan_setara_kas
    self.populate_piutang_usaha
    self.populate_persediaan_barang
    self.populate_uang_muka_pembelian
    self.populate_pajak_dibayar_di_muka
    self.populate_biaya_dibayar_di_muka
    self.populate_aset_tetap
    self.populate_hutang_bank_jangka_pendek
    self.populate_hutang_usaha
    self.populate_hutang_pajak
    self.populate_biaya_yg_masih_harus_dibayar
    self.populate_hutang_bank_jangka_panjang
  end
  
  def self.populate_kas_dan_setara_kas
    @worksheet.add_cell(@row,1, "01.")
    @worksheet.add_cell(@row,2, "Kas dan Setara Kas :")
    @row += 1
    @worksheet.add_cell(@row,2, "a.")
    @worksheet.add_cell(@row,3, "Kas")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    kas_group = CashBank.where(:is_bank => false)
    total_amount_kas = BigDecimal("0")
    kas_group.each do |kas|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => kas.account_id ).first
       amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, kas.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_amount_kas += vc.amount
      @row += 1
    end
    @row += 1
    @worksheet.add_cell(@row,7, total_amount_kas)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 1
    
    @worksheet.add_cell(@row,2, "b.")
    @worksheet.add_cell(@row,3, "Bank :")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    bank_group = CashBank.where(:is_bank => true)
    total_amount_bank = BigDecimal("0")
    bank_group.each do |kas|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => kas.account_id ).first
       amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, kas.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_amount_bank += vc.amount
      @row += 1
    end
    @row += 1
    @worksheet.add_cell(@row,7, total_amount_bank)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 1
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_amount_kas + total_amount_bank)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_piutang_usaha
    @worksheet.add_cell(@row,1, "02.")
    @worksheet.add_cell(@row,2, "Piutang Usaha")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    end_date = @end_date
    piutang_group = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_1][:code])
    account_list = []
    piutang_group.leaves.each {|x| account_list << x.id}
    # acc_id = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_2][:code]).id
    # account = Account.find_by_code(ACCOUNT_CODE[:piutang_usaha_level_1][:code])
    td_group =  TransactionDataDetail.joins(:transaction_data,:account,:contact).where{
      ( account_id.in account_list ) &
      ( transaction_data.transaction_datetime.lt end_date) &
      ( contact_id != 0)
    }
   
    total_piutang_lainnya = BigDecimal("0")
    total_piutang = BigDecimal("0")
    total_hash = {}
    td_group.all.each do |tdd|
      total_hash[tdd.contact_id] = BigDecimal("0")
    end
    td_group.each do |tdd|
        if tdd.entry_case == NORMAL_BALANCE[:credit]
          total_hash[tdd.contact_id] -= tdd.amount
        else
          total_hash[tdd.contact_id] += tdd.amount
        end
    end
    td_group.select(:contact_id).uniq.each do |tdd|
      if total_hash[tdd.contact_id] > BigDecimal("99999999")
        @worksheet.add_cell(@row,3, "-")
        @worksheet.add_cell(@row,4, tdd.contact.name)
        @worksheet.add_cell(@row,7, total_hash[tdd.contact_id])
        @worksheet[@row][7].set_number_format '#,###'
        @row += 1
      else
        total_piutang_lainnya += total_hash[tdd.contact_id]
      end
      total_piutang += total_hash[tdd.contact_id]
    end
    @worksheet.add_cell(@row,3, "-")
    @worksheet.add_cell(@row,4, "LAIN-LAIN")
    @worksheet.add_cell(@row,7, total_piutang_lainnya)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 1
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_piutang)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_persediaan_barang
    @worksheet.add_cell(@row,1, "03.")
    @worksheet.add_cell(@row,2, "Persediaan Barang :")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    persedian_barang_group = Account.find_by_code( "110501" )
        
    total_persediaan_barang = BigDecimal('0')
        
    persedian_barang_group.leaves.order("code ASC").each do |persedian_barang|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => persedian_barang.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, persedian_barang.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_persediaan_barang += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_persediaan_barang)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_uang_muka_pembelian
    @worksheet.add_cell(@row,1, "04.")
    @worksheet.add_cell(@row,2, "Uang Muka Pembelian")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
        
    end_date = @end_date
    total_uang_muka_pembelian = BigDecimal("0")
    
    # IMPORT
    acc_id =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_impor][:code]).id
    account =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_impor][:code] )
    @worksheet.add_cell(@row,3, "-")
    @worksheet.add_cell(@row,4, account.name)
    @row += 1
  
    td_group =  TransactionDataDetail.joins(:transaction_data,:account,:contact).where{
      ( account_id == acc_id )  &
      ( transaction_data.transaction_datetime.lt end_date) &
      ( contact_id != 0)
    }
    total_hash = {}
    td_group.all.each do |tdd|
      total_hash[tdd.contact_id] = BigDecimal("0")
    end
    td_group.each do |tdd|
        if tdd.entry_case == NORMAL_BALANCE[:credit]
          total_hash[tdd.contact_id] -= tdd.amount
        else
          total_hash[tdd.contact_id] += tdd.amount
        end
    end
    td_group.select(:contact_id).uniq.each do |tdd|
      if total_hash[tdd.contact_id] > 0
        @worksheet.add_cell(@row,4, "-")
        @worksheet.add_cell(@row,5, tdd.contact.name)
        @worksheet.add_cell(@row,7, total_hash[tdd.contact_id])
        @worksheet[@row][7].set_number_format '#,###'
        @row += 1
        total_uang_muka_pembelian += total_hash[tdd.contact_id]
      end
    end
    
    # LOKAL
    acc_id =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_lokal][:code]).id
    account =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_pembelian_lokal][:code] )
    @worksheet.add_cell(@row,3, "-")
    @worksheet.add_cell(@row,4, account.name)
    @row += 1
    td_group =  TransactionDataDetail.joins(:transaction_data,:account,:contact).where{
      ( account_id == acc_id ) &
      ( transaction_data.transaction_datetime.lt end_date) &
      ( contact_id != 0)
    }
    total_hash = {}
    td_group.all.each do |tdd|
      total_hash[tdd.contact_id] = BigDecimal("0")
    end
    td_group.each do |tdd|
      if tdd.entry_case == NORMAL_BALANCE[:credit]
        total_hash[tdd.contact_id] -= tdd.amount
      else
        total_hash[tdd.contact_id] += tdd.amount
      end
    end
    td_group.select(:contact_id).uniq.each do |tdd|
      if total_hash[tdd.contact_id] > 0
        @worksheet.add_cell(@row,4, "-")
        @worksheet.add_cell(@row,5, tdd.contact.name)
        @worksheet.add_cell(@row,7, total_hash[tdd.contact_id])
        @worksheet[@row][7].set_number_format '#,###'
        @row += 1
        total_uang_muka_pembelian += total_hash[tdd.contact_id]
      end
    end
    
    # LAINNYA
    account_id =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_lainnya][:code]).id
    account =  Account.find_by_code(ACCOUNT_CODE[:uang_muka_lainnya][:code] )
    vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
    amount = BigDecimal('0')
    if not vc.nil?
      amount = vc.amount
    else
      amount = 0
    end
    @worksheet.add_cell(@row,4, "-")
    @worksheet.add_cell(@row,5, account.name)
    @worksheet.add_cell(@row,7, amount)
    @worksheet[@row][7].set_number_format '#,###'
    total_uang_muka_pembelian += amount
    @row += 1
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_uang_muka_pembelian)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_pajak_dibayar_di_muka
    @worksheet.add_cell(@row,1, "05.")
    @worksheet.add_cell(@row,2, "Pajak Dibayar di Muka")
    @row += 1
    account_group = Account.find_by_code( "110701" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end 
  
  def self.populate_biaya_dibayar_di_muka
    @worksheet.add_cell(@row,1, "06.")
    @worksheet.add_cell(@row,2, "Biaya Dibayar di Muka")
    @row += 1
    account_group = Account.find_by_code( "110801" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_aset_tetap
    @worksheet.add_cell(@row,1, "07.")
    @worksheet.add_cell(@row,2, "Aset Tetap :")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    account_group = Account.find_by_code( "14" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        if account.parent_id == Account.find_by_code( "140801" ).id
          amount = vc.amount * -1
        else
          amount = vc.amount
        end
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_hutang_bank_jangka_pendek
    @worksheet.add_cell(@row,1, "08.")
    @worksheet.add_cell(@row,2, "Hutang Bank Jangka Pendek")
    @row += 1
    account_group = Account.find_by_code( "2101" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_hutang_usaha
    @worksheet.add_cell(@row,1, "09.")
    @worksheet.add_cell(@row,2, "Hutang Usaha")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    end_date = @end_date
    piutang_group = Account.find_by_code(ACCOUNT_CODE[:hutang_usaha_level_1][:code])
    account_list = []
    piutang_group.leaves.each {|x| account_list << x.id}
    td_group =  TransactionDataDetail.joins(:transaction_data,:account,:contact).where{
      ( account_id.in account_list ) &
      ( transaction_data.transaction_datetime.lt end_date) &
      ( contact_id != nil)
    }
    total_hash = {}
    td_group.all.each do |tdd|
      total_hash[tdd.contact_id] = BigDecimal("0")
    end
    td_group.each do |tdd|
      if tdd.entry_case == NORMAL_BALANCE[:debit]
        total_hash[tdd.contact_id] -= tdd.amount
      else
        total_hash[tdd.contact_id] += tdd.amount
      end
    end
    total_piutang = BigDecimal("0")
    td_group.select(:contact_id).uniq.each do |tdd|
      if total_hash[tdd.contact_id] > 0
        @worksheet.add_cell(@row,3, "-")
        @worksheet.add_cell(@row,4, tdd.contact.name)
        @worksheet.add_cell(@row,7, total_hash[tdd.contact_id])
        @worksheet[@row][7].set_number_format '#,###'
        @row += 1
        total_piutang += total_hash[tdd.contact_id]
      end
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_piutang)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
    
  end
  
  def self.populate_hutang_pajak
    @worksheet.add_cell(@row,1, "10.")
    @worksheet.add_cell(@row,2, "Hutang Pajak :")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    account_group = Account.find_by_code( "2105" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
    
  def self.populate_biaya_yg_masih_harus_dibayar
    @worksheet.add_cell(@row,1, "11.")
    @worksheet.add_cell(@row,2, "Biaya Yang Masih Harus Dibayar :")
    @row += 1
    @worksheet.add_cell(@row,3, "Terdiri dari :")
    @row += 1
    account_group = Account.find_by_code( "2106" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
  
  def self.populate_hutang_bank_jangka_panjang
    @worksheet.add_cell(@row,1, "12.")
    @worksheet.add_cell(@row,2, "Hutang Bank Jangka Panjang")
    @row += 1
    account_group = Account.find_by_code( "2101" )
        
    total_account = BigDecimal('0')
        
    account_group.leaves.order("code ASC").each do |account|
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => account.id ).first
      amount = BigDecimal('0')
      if not vc.nil?
        amount = vc.amount
      else
        amount = 0
      end
      @worksheet.add_cell(@row,3, "-")
      @worksheet.add_cell(@row,4, account.name)
      @worksheet.add_cell(@row,7, amount)
      @worksheet[@row][7].set_number_format '#,###'
      total_account += vc.amount
      @row += 1
    end
    @worksheet.add_cell(@row,4, "Jumlah")
    @worksheet.add_cell(@row,7, total_account)
    @worksheet[@row][7].set_number_format '#,###'
    @row += 2
  end
end