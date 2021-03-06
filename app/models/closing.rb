class Closing < ActiveRecord::Base
  has_many :valid_combs
  has_many :closing_details
  validates_presence_of :period
  validates_presence_of :year_period
  # validates_presence_of :beginning_period
  validates_presence_of :end_date_period
  # validates_presence_of :is_year
  
  validate :end_period_must_be_later_than_any_start_period
  
  
  def self.active_objects
    return self
  end
  
  def active_children
    return self.closing_details
  end
  
  def self.is_date_closed(check_date)
    begin_date = check_date
    end_date = check_date + 1.days
    return Closing.where{
      (is_closed.eq true) &
      (beginning_period.lte begin_date) &
      (end_date_period.gt end_date)
    } 
    
  end
  
  def end_period_must_be_later_than_any_start_period
    return if not end_date_period.present? 
    current_end_period = self.end_date_period 
    if self.persisted?
      current_closing_id = self.id 
      if Closing.where{
        ( id.not_eq current_closing_id ) & (
          ( beginning_period.gte  current_end_period ) | 
          ( end_date_period.gte current_end_period )
        )
        
      }.count > 1
        self.errors.add(:end_period, "Sudah ada closing yang tanggal mulai lebih akhir daripada tanggal end_period anda")
        return self 
      end
      
    else
      if Closing.where{
        ( beginning_period.gte  current_end_period ) | 
        ( end_date_period.gte current_end_period )
      }.count > 0 
        self.errors.add(:end_period, "Sudah ada closing yang tanggal mulai lebih akhir daripada tanggal end_period anda")
        return self 
      end
    end
    
  end
  
  def self.create_object( params) 
    new_object = self.new 
    new_object.period = params[:period]
    new_object.year_period = params[:year_period]
    new_object.beginning_period = params[:beginning_period]
    new_object.end_date_period = params[:end_date_period]
    new_object.is_year_closing = params[:is_year_closing]
    if new_object.save
      new_object.generate_closing_detail(new_object.id)
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_closed? 
      self.errors.add(:generic_errors, "Sudah di close")
      return self
    end
    self.period = params[:period]
    self.year_period = params[:year_period]
    self.beginning_period = params[:beginning_period]
    self.end_date_period = params[:end_date_period]
    self.is_year_closing = params[:is_year_closing]
    if self.save
      self.closing_details.each do |clsd|
        clsd.delete_object
      end
      generate_closing_detail(self.id)
    end
    return self
  end
  
  def close_object(params)
    if self.is_closed? 
      self.errors.add(:generic_errors, "Sudah di close")
      return self
    end
     if params[:closed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal Closing")
      return self 
    end  
    self.is_closed = true
    self.closed_at = params[:closed_at]
    # self.closing_details.each do |cd|
    #   latest_exchange_rate = ExchangeRate.get_latest(
    #       :ex_rate_date => self.end_date_period,
    #       :exchange_id => cd.exchange_id
    #     )
    #   if latest_exchange_rate.nil?
    #     self.errors.add(:generic_errors, "ExchangeRate untuk #{cd.exchange.name} belum di input")
    #     return self 
    #   end
    # end
    
    if self.save
      self.generate_valid_combs
      self.generate_valid_combs_for_non_children
    end
    # g = []
    # Account.all.each {|x| g << [x.id,x.name]}
    
    # h =[]
    # ValidComb.all.each {|x| h << [x.account_id]}
    
    # puts "Account count #{Account.all.count}"
    # puts "ValidComb count #{ValidComb.all.count}"
    return self
  end
  
  def open_object
    if self.is_closed == false
      self.errors.add(:generic_errors, "belum di close")
      return self 
    end
    self.is_closed =false
    self.closed_at = nil
    if self.save
      AccountingService::CreateExchangeGainLossJournal.undo_create_exchange_gain_loss_journal(self)
      ValidComb.where(:closing_id => self.id).each do |valid_comb|
        if not valid_comb.valid_comb_non_base_exchange.nil?
          valid_comb.valid_comb_non_base_exchange.delete_object
        end
          valid_comb.delete_object  
      end
    end  
  end
  
  
  def delete_object
    if self.is_closed?
      self.errors.add(:generic_errors, "Sudah di close")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def generate_closing_detail(closing_id)
    Exchange.all.each do |exc|
      ClosingDetail.create_object(
        :closing_id => closing_id,
        :exchange_id => exc.id)
    end
  end
  
  def previous_closing 
    previous = nil 
    current_end_period = self.beginning_period
    if self.persisted?
      current_id = self.id 
      previous = Closing.where{
        (id.not_eq current_id) & (
          (end_date_period.lt current_end_period)
        )
        
      }.order("end_date_period DESC").first
    else
      previous = Closing.where{
        (end_date_period.lt current_end_period)
      }.order("end_date_period DESC").first
    end
    return previous 
  end
  
  
  def generate_valid_combs
    self.generate_exchange_gain_loss
    start_transaction = beginning_period
    end_transaction = end_date_period
    leaves_account = Account.all_ledger_accounts
    # leaves_account_id_list = leaves_account.map{|x| x.id }
    leaves_account.each do |leaf_account|
      valid_comb_amount = BigDecimal("0")
      valid_comb_amount_non_idr = BigDecimal("0")
      total_debit = BigDecimal("0")
      total_credit = BigDecimal("0")
      total_debit_non_idr = BigDecimal("0")
      total_credit_non_idr = BigDecimal("0")
      cash_bank = CashBank.where(:account_id => leaf_account.id)
      account_payable = Exchange.where(:account_payable_id => leaf_account.id)
      account_receivable = Exchange.where(:account_receivable_id => leaf_account.id)
      gbch_payable = Exchange.where(:gbch_payable_id => leaf_account.id)
      gbch_receivable = Exchange.where(:gbch_receivable_id => leaf_account.id)
    
      if not start_transaction.nil?
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lte end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lte end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
        
        if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
          gbch_payable.count > 0 or gbch_receivable.count > 0
            total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
            total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
        end
      else
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lte end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")
  
        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lte end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
      
        if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
          gbch_payable.count > 0 or gbch_receivable.count > 0
            total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
            total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
        end  
      
      end
      # puts "#{leaf_account.name} (#{leaf_account.code}) (#{leaf_account.normal_balance}) total_debit = #{total_debit}  total_credit = #{total_credit}"
      if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
        valid_comb_amount = total_debit - total_credit
        valid_comb_amount_non_idr = total_debit_non_idr - total_credit_non_idr
      else
        valid_comb_amount = total_credit -  total_debit
        valid_comb_amount_non_idr = total_credit_non_idr - total_debit_non_idr
      end
    
      final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
      final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + ValidCombNonBaseExchange.previous_closing_valid_comb_amount(previous_closing,leaf_account)
      entry_case = leaf_account.normal_balance  
      
      if final_valid_comb_amount < BigDecimal("0")
        entry_case = NORMAL_BALANCE[:debit] if leaf_account.normal_balance == NORMAL_BALANCE[:credit] 
        entry_case = NORMAL_BALANCE[:credit] if leaf_account.normal_balance == NORMAL_BALANCE[:debit] 
      end
      
      
      # puts " #{leaf_account.id} #{leaf_account.name} (#{leaf_account.code}) :: #{valid_comb_amount} "
      
      valid_comb = ValidComb.create_object(
        :account_id => leaf_account.id,
        :closing_id => self.id,
        :amount => final_valid_comb_amount.abs,
        :entry_case => entry_case
      )
      
      if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
        gbch_payable.count > 0 or gbch_receivable.count > 0
        ValidCombNonBaseExchange.create_object(
        :valid_comb_id => valid_comb.id,
        :amount => final_valid_comb_amount_non_idr.abs
        )  
      end
      
    end
    self.generate_laba_rugi_valid_comb
    parent_id_list = leaves_account.map{|x| x.parent_id }.uniq
    
    if parent_id_list.length != 0
      generate_parent_valid_combs(  parent_id_list ) 
    end
    
  end
  
  
  def generate_laba_rugi_valid_comb
    penjualan_group = Account.find_by_code(ACCOUNT_CODE[:pendapatan_penjualan_level_1][:code] )
    penjualan_amount = BigDecimal('0')
    penjualan_group.leaves.each do |pjd|
      vc = ValidComb.where(:closing_id => self.id , :account_id => pjd.id ).first
      penjualan_amount = penjualan_amount + vc.amount
    end
    
    retur_group =  Account.find_by_code(ACCOUNT_CODE[:retur_penjualan_level_1][:code] )
    retur_amount = BigDecimal('0')
    retur_group.leaves.each do |pjd|
      vc = ValidComb.where(:closing_id => self.id , :account_id => pjd.id ).first
      retur_amount = retur_amount + vc.amount
    end
    
    pendapatan_lain_lain_group = Account.find_by_code(ACCOUNT_CODE[:pendapatan_lain_lain][:code] )
    pendapatan_lain_lain_amount = BigDecimal('0')
    pendapatan_lain_lain_group.leaves.each do |pjd|
      vc = ValidComb.where(:closing_id => self.id , :account_id => pjd.id ).first
      pendapatan_lain_lain_amount = pendapatan_lain_lain_amount + vc.amount
    end
    
    beban_group =  Account.find_by_code( ACCOUNT_CODE[:beban_usaha][:code] )
    beban_amount = BigDecimal('0')
    beban_group.leaves.each do |pjd|
      vc = ValidComb.where(:closing_id => self.id , :account_id => pjd.id ).first
      beban_amount = beban_amount + vc.amount
    end
    
    pph_group = Account.find_by_code( ACCOUNT_CODE[:pajak_penghasilan_level_1][:code] )
    pph_amount = BigDecimal('0')
    pph_group.leaves.each do |pjd|
      vc = ValidComb.where(:closing_id => self.id , :account_id => pjd.id ).first
      pph_amount = pph_amount + vc.amount
    end
    
    total_laba_rugi = BigDecimal('0')
    total_laba_rugi = penjualan_amount - retur_amount - beban_amount + pendapatan_lain_lain_amount - pph_amount
    
    laba_rugi_bulan_berjalan = Account.find_by_code( ACCOUNT_CODE[:laba_rugi_bulan_berjalan_level_3][:code] )
    vc_laba_rugi_bulan_berjalan = ValidComb.find_by_account_id(laba_rugi_bulan_berjalan.id)
    vc_laba_rugi_bulan_berjalan.amount = vc_laba_rugi_bulan_berjalan.amount + total_laba_rugi
    vc_laba_rugi_bulan_berjalan.save
    
    laba_rugi_tahun_berjalan = Account.find_by_code(ACCOUNT_CODE[:laba_rugi_tahun_berjalan_level_3][:code])
    vc_laba_rugi_tahun_berjalan = ValidComb.find_by_account_id(laba_rugi_tahun_berjalan.id)
    vc_laba_rugi_tahun_berjalan.amount = vc_laba_rugi_tahun_berjalan.amount +
    vc_laba_rugi_bulan_berjalan.amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, laba_rugi_tahun_berjalan )
    vc_laba_rugi_bulan_berjalan.save
    
    if not previous_closing.nil?
      if previous_closing.is_year_closing == true
        laba_rugi_ditahan = Account.find_by_code(ACCOUNT_CODE[:laba_rugi_ditahan_level_3][:code])
        vc_laba_rugi_ditahan = ValidComb.find_by_account_id(laba_rugi_ditahan.id)
        vc_laba_rugi_ditahan.amount = ValidComb.previous_closing_valid_comb_amount( previous_closing, laba_rugi_ditahan ) +
        vc_laba_rugi_bulan_berjalan.amount + vc_laba_rugi_bulan_berjalan.amount
        vc_laba_rugi_ditahan.save
      end
    end
    
  end
  
  def generate_exchange_for_cash_bank(transaction_data_id,cash_bank,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => cash_bank.exchange_id).first
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_cash_bank_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => cash_bank.account_id
     )
    
  end 
  
  def generate_exchange_for_account_payable(transaction_data_id,account_payable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => account_payable.id).first
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_account_payable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => account_payable.account_payable_id
     )
    
  end 
  
  def generate_exchange_for_account_receivable(transaction_data_id,account_receivable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => account_receivable.id).first
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
   
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    # puts final_valid_comb_amount
    # puts final_valid_comb_amount_non_idr
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_account_receivable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => account_receivable.account_receivable_id
     )
    
  end 
  
  def generate_exchange_for_gbch_payable(transaction_data_id,gbch_payable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => gbch_payable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => gbch_payable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_payable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => gbch_payable.gbch_payable_id
     )
    
  end 
  
  def generate_exchange_for_gbch_receivable(transaction_data_id,gbch_receivable,start_transaction,end_transaction,leaf_account_id,leaf_account)
    valid_comb_amount = BigDecimal("0")
    valid_comb_amount_non_idr = BigDecimal("0")
    total_debit = BigDecimal("0")
    total_credit = BigDecimal("0")
    total_debit_non_idr = BigDecimal("0")
    total_credit_non_idr = BigDecimal("0")
    latest_rate = self.closing_details.where(
      :exchange_id => gbch_receivable.id).first
    # latest_rate = ExchangeRate.get_latest( 
    #   :ex_rate_date => end_transaction , 
    #   :exchange_id => gbch_receivable.id  )
    if not start_transaction.nil?
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.gte start_transaction) & 
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
    
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.gte start_transaction) & 
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    else
      total_debit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:debit])
      }.sum("amount")
    
      total_credit = TransactionDataDetail.joins(:transaction_data).where{
        ( transaction_data.transaction_datetime.lte end_transaction) & 
        ( account_id.eq leaf_account.id ) & 
        ( entry_case.eq NORMAL_BALANCE[:credit])
      }.sum("amount")
      
      total_debit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:debit])
            }.sum("amount")
          
      total_credit_non_idr = TransactionDataNonBaseExchangeDetail.joins(:transaction_data_detail => [:transaction_data])
            .where{
            ( transaction_data_detail.transaction_data.transaction_datetime.lte end_transaction) & 
            ( transaction_data_detail.account_id.eq leaf_account.id ) & 
            ( transaction_data_detail.entry_case.eq NORMAL_BALANCE[:credit])
            }.sum("amount")
    end
    
    if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
      valid_comb_amount = total_debit - total_credit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_credit_non_idr) * latest_rate.rate).round(2)
    else
      valid_comb_amount = total_credit -  total_debit
      valid_comb_amount_non_idr = ((total_debit_non_idr - total_debit_non_idr) * latest_rate.rate).round(2)
    end
    
    final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
    final_valid_comb_amount_non_idr = valid_comb_amount_non_idr + 
      (ValidCombNonBaseExchange.previous_closing_valid_comb_amount( previous_closing,leaf_account ) *
      latest_rate.rate).round(2)
    AccountingService::CreateExchangeGainLossJournal.create_exchange_gain_loss_gbch_receivable_journal(
     :transaction_data_id => transaction_data_id,
     :valid_comb_amount => final_valid_comb_amount,
     :valid_comb_amount_non_idr => final_valid_comb_amount_non_idr,
     :account_id => gbch_receivable.gbch_receivable_id
     )
    
  end 
  
  
  def generate_exchange_gain_loss
    start_transaction = beginning_period
    end_transaction = end_date_period
    transaction_data = AccountingService::CreateExchangeGainLossJournal.create_master_transaction_journal(
      :transaction_datetime => end_transaction,
      :transaction_source_id => self.id,
      :transaction_source_type => self.class.to_s,
      )
    leaves_account = Account.all_ledger_accounts
    
    leaves_account.each do |leaf_account|
    leaid = leaf_account.id
    cash_bank = CashBank.joins(:exchange).where{
                (account_id.eq leaid) &
                (exchange.is_base.eq false)
                }
    account_payable = Exchange.where(:account_payable_id => leaf_account.id,:is_base => false)
    account_receivable = Exchange.where(:account_receivable_id => leaf_account.id,:is_base => false)
    gbch_payable = Exchange.where(:gbch_payable_id => leaf_account.id,:is_base => false)
    gbch_receivable = Exchange.where(:gbch_receivable_id => leaf_account.id,:is_base => false)
    if cash_bank.count > 0 or account_payable.count > 0 or account_receivable.count > 0 or 
      gbch_payable.count > 0 or gbch_receivable.count > 0
      if cash_bank.count > 0 
        generate_exchange_for_cash_bank(transaction_data.id,cash_bank.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end
      
      if account_payable.count > 0
        generate_exchange_for_account_payable(transaction_data.id,account_payable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if account_receivable.count > 0  
        generate_exchange_for_account_receivable(transaction_data.id,account_receivable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if gbch_payable.count > 0  
        generate_exchange_for_gbch_payable(transaction_data.id,gbch_payable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
      
      if gbch_receivable.count > 0  
        generate_exchange_for_gbch_receivable(transaction_data.id,gbch_receivable.first,start_transaction,end_transaction,leaf_account.id,leaf_account)
      end 
    end
    end
    transaction_data.reload
    if  transaction_data.transaction_data_details.count == 0 
      transaction_data.delete_object
    else
      transaction_data.confirm
      transaction_data.reload
      transaction_data.transaction_data_details.each do |x|
        puts "#{x.amount.to_s}  |  #{x.description}  |  #{x.account_id}"
      end
    end
  end 
  
  
 
  
  def generate_valid_combs_for_non_children
    Account.roots.each do |x|
      next if x.children.count != 0 
      valid_comb = ValidComb.create_object(
        :account_id => x.id,
        :closing_id => self.id,
        :amount => BigDecimal("0"),
        :entry_case => x.normal_balance
      )
    end
  end
  
  def generate_parent_valid_combs( node_id_list )
    node_account_list = Account.where(:id => node_id_list)
    node_account_list.each do | node | 
      next if ValidComb.where(:closing_id => self.id, :account_id => node.id).count == 1 
      children = node.children
      total_debit = ValidComb.where(
        :closing_id => self.id,
        :account_id => node.children.map{|x| x.id},
        :entry_case => NORMAL_BALANCE[:debit]
      ).sum("amount")
      
      
      total_credit = ValidComb.where(
        :closing_id => self.id,
        :account_id => node.children.map{|x| x.id},
        :entry_case => NORMAL_BALANCE[:credit]
      ).sum("amount")
      
      valid_comb_amount= BigDecimal("0")
      
      if node.normal_balance == NORMAL_BALANCE[:debit]
        valid_comb_amount = total_debit - total_credit
      else
        valid_comb_amount = total_credit -  total_debit
      end
      
      
      final_valid_comb_amount = valid_comb_amount 
      # + ValidComb.previous_closing_valid_comb_amount( previous_closing, node )
      # puts " #{node.name} (#{node.code}) :: #{final_valid_comb_amount} "
      entry_case = node.normal_balance  
      
      if final_valid_comb_amount < BigDecimal("0")
        entry_case = NORMAL_BALANCE[:debit] if node.normal_balance == NORMAL_BALANCE[:credit] 
        entry_case = NORMAL_BALANCE[:credit] if node.normal_balance == NORMAL_BALANCE[:debit] 
      end
      
      
      valid_comb = ValidComb.create_object(
        :account_id => node.id,
        :closing_id => self.id,
        :amount => final_valid_comb_amount.abs,
        :entry_case => entry_case
      )
      
      
    end
    
    parent_id_list = node_account_list.map{|x| x.parent_id }.uniq
    
    if parent_id_list.length != 0
      generate_parent_valid_combs(  parent_id_list ) 
    end
  end
  
end
