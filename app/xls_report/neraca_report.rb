class NeracaReport
    
  def self.create_report( filepath, start_date, end_date, closing  )
    @closing  = closing
    @start_date = start_date
    @end_date = end_date         
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
    @worksheet.add_cell(1,0, "NERACA")
    @worksheet.merge_cells(2, 0, 2, 15) 
    duration_string = "#{@end_date.day}-#{@end_date.month}-#{@end_date.year}"
    @worksheet.add_cell(2,0, "Per #{@end_date}")
    @worksheet.add_cell(3,0, "Unit : RP.")
  end
  
  def self.populate_content
    self.populate_aktiva
    self.populate_kewajiban
  end
  
  def self.populate_aktiva
    @worksheet.add_cell(5,0, "AKTIVA")
    @worksheet.add_cell(6,0, "AKTIVA LANCAR")
    @worksheet.add_cell(7,1, "Kas dan Setara Kas")
    acc = Account.find_by_code( "1101" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    kas_dan_setara_kas_amount = BigDecimal('0')
    if not vc.nil?
      kas_dan_setara_kas_amount = vc.amount
    else
      kas_dan_setara_kas_amount = 0
    end
    @worksheet.add_cell(7, 6, kas_dan_setara_kas_amount  )   
    
    @worksheet.add_cell(8,1, "Deposito Berjangka")  
    acc = Account.find_by_code( "1102" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    deposito_berjangka_amount = BigDecimal('0')
    if not vc.nil?
      deposito_berjangka_amount = vc.amount
    else
      deposito_berjangka_amount = 0
    end
    @worksheet.add_cell(8, 6, deposito_berjangka_amount  ) 
    
    @worksheet.add_cell(9,1, "Piutang Usaha")  
    acc = Account.find_by_code( "1103" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end  
    piutang_usaha_amount = BigDecimal('0')
    if not vc.nil?
      piutang_usaha_amount = vc.amount
    else
      piutang_usaha_amount = 0
    end
    @worksheet.add_cell(9, 6, piutang_usaha_amount  )  
    
    
    @worksheet.add_cell(10,1, "Piutang Lain-Lain")  
    acc = Account.find_by_code( "1104" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    piutang_lain_lain_amount = BigDecimal('0')
    if not vc.nil?
      piutang_lain_lain_amount = vc.amount
    else
      piutang_lain_lain_amount = 0
    end
    @worksheet.add_cell(10, 6, piutang_lain_lain_amount  )  
    
    @worksheet.add_cell(11,1, "Persediaan Barang")  
    acc = Account.find_by_code( "1105" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    persediaan_barang_amount = BigDecimal('0')
    if not vc.nil?
      persediaan_barang_amount = vc.amount
    else
      persediaan_barang_amount = 0
    end
    @worksheet.add_cell(11, 6, persediaan_barang_amount  )  
    
    @worksheet.add_cell(12,1, "Uang Muka Pembelian")  
    acc = Account.find_by_code( "1106" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    uang_muka_pembelian_amount = BigDecimal('0')
    if not vc.nil?
      uang_muka_pembelian_amount = vc.amount
    else
      uang_muka_pembelian_amount = 0
    end
    @worksheet.add_cell(12, 6, uang_muka_pembelian_amount  )  
    
    @worksheet.add_cell(13,1, "Pajak dibayar di muka") 
    acc = Account.find_by_code( "1107" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    pajak_dibayar_di_muka_amount = BigDecimal('0')
    if not vc.nil?
      pajak_dibayar_di_muka_amount = vc.amount
    else
      pajak_dibayar_di_muka_amount = 0
    end
    @worksheet.add_cell(13, 6, pajak_dibayar_di_muka_amount  )  
    
    @worksheet.add_cell(14,1, "Biaya dibayar di muka")  
    acc = Account.find_by_code( "2" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    biaya_dibayar_di_muka_amount = BigDecimal('0')
    if not vc.nil?
      biaya_dibayar_di_muka_amount = vc.amount
    else
      biaya_dibayar_di_muka_amount = 0
    end
    @worksheet.add_cell(14, 6, biaya_dibayar_di_muka_amount  )  
    
    @worksheet.add_cell(15,2, "Jumlah Aktiva Lancar")
    jumlah_aktiva_lancar = BigDecimal('0')
    jumlah_aktiva_lancar = kas_dan_setara_kas_amount + deposito_berjangka_amount +
                          piutang_usaha_amount + piutang_lain_lain_amount +
                          persediaan_barang_amount + uang_muka_pembelian_amount +
                          pajak_dibayar_di_muka_amount + biaya_dibayar_di_muka_amount
    @worksheet.add_cell(15, 6, jumlah_aktiva_lancar  ) 
     
    @worksheet.add_cell(18,0, "AKTIVA TIDAK LANCAR")
    @worksheet.add_cell(19,1, "Aktiva Tetap")
    acc = Account.find_by_code( "14" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    aktiva_tetap_amount = BigDecimal('0')
    if not vc.nil?
      aktiva_tetap_amount = vc.amount
    else
      aktiva_tetap_amount = 0
    end
    @worksheet.add_cell(19,6, aktiva_tetap_amount)
  
    @worksheet.add_cell(20,2, "Setelah dikurangi akumulasi")
    acc = Account.find_by_code( "1408" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    akumulasi_penyusutan_amount = BigDecimal('0')
    if not vc.nil?
      akumulasi_penyusutan_amount = vc.amount
    else
      akumulasi_penyusutan_amount = 0
    end
    @worksheet.add_cell(21,2, "Penyusutan sebesar")
    @worksheet.add_cell(21,6, akumulasi_penyusutan_amount)
    @worksheet.add_cell(23,2, "Jumlah Aktiva Tidak Lancar")
    jumlah_aktiva_tidak_lancar = aktiva_tetap_amount - akumulasi_penyusutan_amount
    @worksheet.add_cell(23,6, jumlah_aktiva_tidak_lancar)
    
    @worksheet.add_cell(26,0, "JUMLAH AKTIVA")
    jumlah_aktiva = jumlah_aktiva_lancar + jumlah_aktiva_tidak_lancar
    @worksheet.add_cell(26,6, jumlah_aktiva)
  end
  
  def self.populate_kewajiban
    @worksheet.add_cell(5,9, "KEWAJIBAN DAN EKUITAS")
    @worksheet.add_cell(6,9, "KEWAJIBAN LANCAR")
    @worksheet.add_cell(7,10, "Hutang Bank")
    acc = Account.find_by_code( "2101" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    hutang_bank_amount = BigDecimal('0')
    if not vc.nil?
      hutang_bank_amount = vc.amount
    else
      hutang_bank_amount = 0
    end
    @worksheet.add_cell(7,15, hutang_bank_amount)
    
    @worksheet.add_cell(8,10, "Hutang Usaha")  
    acc = Account.find_by_code( "2102" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    hutang_usaha_amount = BigDecimal('0')
    if not vc.nil?
      hutang_usaha_amount = vc.amount
    else
      hutang_usaha_amount = 0
    end
    @worksheet.add_cell(8,15, hutang_usaha_amount)
    
    @worksheet.add_cell(9,10, "Hutang Lain-lain") 
    acc = Account.find_by_code( "2103" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    hutang_lain_lain_amount = BigDecimal('0')
    if not vc.nil?
      hutang_lain_lain_amount = vc.amount
    else
      hutang_lain_lain_amount = 0
    end
    @worksheet.add_cell(9,15, hutang_lain_lain_amount)
    
    @worksheet.add_cell(10,10, "Hutang Pajak")  
    acc = Account.find_by_code( "2103" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    hutang_pajak_amount = BigDecimal('0')
    if not vc.nil?
      hutang_pajak_amount = vc.amount
    else
      hutang_pajak_amount = 0
    end
    @worksheet.add_cell(10,15, hutang_pajak_amount)
    
    @worksheet.add_cell(11,10, "Biaya Yang Masih Harus Dibayar")  
    acc = Account.find_by_code( "2106" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    biaya_yang_masih_harus_dibayar_amount = BigDecimal('0')
    if not vc.nil?
      biaya_yang_masih_harus_dibayar_amount = vc.amount
    else
      biaya_yang_masih_harus_dibayar_amount = 0
    end
    @worksheet.add_cell(11,15, biaya_yang_masih_harus_dibayar_amount)
    
    @worksheet.add_cell(12,12, "Jumlah Kewajiban")  
    jumlah_kewajiban = hutang_bank_amount + hutang_usaha_amount +
                       hutang_lain_lain_amount + hutang_pajak_amount +
                       biaya_yang_masih_harus_dibayar_amount
    @worksheet.add_cell(12,15, jumlah_kewajiban)
    
    @worksheet.add_cell(13,9, "KEWAJIBAN JANGKA PANJANG")  
    @worksheet.add_cell(14,10, "Kewajiban Jangka Panjang")  
    acc = Account.find_by_code( "22" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    kewajiban_jangka_panjang_amount = BigDecimal('0')
    if not vc.nil?
      kewajiban_jangka_panjang_amount = vc.amount
    else
      kewajiban_jangka_panjang_amount = 0
    end
    @worksheet.add_cell(14,15, kewajiban_jangka_panjang_amount)
    
    @worksheet.add_cell(18,9, "EKUITAS")
    @worksheet.add_cell(19,10, "Modal Disetor")
    acc = Account.find_by_code( "31" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    modal_disetor_amount = BigDecimal('0')
    if not vc.nil?
      modal_disetor_amount = vc.amount
    else
      modal_disetor_amount = 0
    end
    @worksheet.add_cell(19,15, modal_disetor_amount)
    
    @worksheet.add_cell(20,10, "Laba Ditahan")
    # acc = Account.find_by_code( "3102" )
    acc = Account.find_by_code( "5" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    laba_ditahan_amount = BigDecimal('0')
    if not vc.nil?
      laba_ditahan_amount = vc.amount
    else
      laba_ditahan_amount = 0
    end
    @worksheet.add_cell(20,15, laba_ditahan_amount)
    
    @worksheet.add_cell(21,10, "Laba bulan Berjalan")
    acc = Account.find_by_code( "3104" )
    vc = nil
    if not acc.nil?
      vc = ValidComb.where(:closing_id => @closing.id , :account_id => acc.id ).first
    end
    laba_bulan_berjalan_amount = BigDecimal('0')
    if not vc.nil?
      laba_bulan_berjalan_amount = vc.amount
    else
      laba_bulan_berjalan_amount = 0
    end
    @worksheet.add_cell(21,15, laba_bulan_berjalan_amount)
    
    @worksheet.add_cell(23,12, "Jumlah Ekuitas")
    jumlah_ekuitas = modal_disetor_amount + laba_ditahan_amount +
                     laba_bulan_berjalan_amount
    @worksheet.add_cell(23,15, jumlah_ekuitas)     
    
    @worksheet.add_cell(26,9, "JUMLAH KEWAJIBAN DAN EKUITAS")  
    jumlah_kewajiban_dan_ekuitas = jumlah_kewajiban + kewajiban_jangka_panjang_amount + 
                                   jumlah_ekuitas
    @worksheet.add_cell(26,15, jumlah_kewajiban_dan_ekuitas)                               
  end
end