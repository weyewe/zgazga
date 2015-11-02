class ReceiptVoucher < ActiveRecord::Base
  validates_presence_of :receipt_date
  # validates_presence_of :due_date
  # validates_presence_of :no_bukti
  validate :valid_cash_bank
  validate :valid_rate_to_idr
  validate :valid_contact
  belongs_to :contact
  belongs_to :cash_bank
  has_many :receipt_voucher_details
  
  
  # self.total_pph_23 + self.biaya_bank + biaya_pembulatan
  
  validates_presence_of :biaya_bank
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.receipt_voucher_details
  end
  
  def valid_contact
    return if  contact_id.nil?
    ct = Contact.find_by_id contact_id
    
    if ct.nil? 
      self.errors.add(:contact_id, "Harus ada contact id")
      return self 
    end
  end 
    
  def valid_cash_bank
    return if  cash_bank_id.nil?
    cb = CashBank.find_by_id cash_bank_id
    
    if cb.nil? 
      self.errors.add(:cash_bank_id, "Harus ada CashBank id")
      return self 
    end
    if is_gbch? and not cb.is_bank?
      self.errors.add(:cash_bank_id, "CashBank harus bank")
      return self 
    end
  end 
  
  def valid_rate_to_idr
    if rate_to_idr <= BigDecimal("0")
      self.errors.add(:rate_to_idr, "Harus lebih besar dari 0")
      return self
    end
  end
  
  
  def self.create_object(params)
    new_object = self.new
    if (params[:is_gbch] == false) & (params[:gbch_no].present?)
      new_object.errors.add(:gbch_no, "GBCH no tidak perlu di isi apabila bukan GBCH")
      return new_object
    elsif (params[:is_gbch] == true) & (not params[:gbch_no].present?)
      new_object.errors.add(:gbch_no, "GBCH no harus di isi apabila GBCH")
      return new_object
    end
    # new_object.no_bukti = params[:no_bukti]
    new_object.no_voucher = params[:no_voucher]
    new_object.is_gbch = params[:is_gbch]
    new_object.gbch_no = params[:gbch_no]
    new_object.due_date = params[:due_date]
    # new_object.pembulatan = BigDecimal(params[:pembulatan] || '0') # params[:pembulatan]
    # new_object.status_pembulatan = params[:status_pembulatan]
    new_object.biaya_bank = BigDecimal(params[:biaya_bank] || '0')# params[:biaya_bank]
    new_object.rate_to_idr =BigDecimal(params[:rate_to_idr] || '0') #params[:rate_to_idr]
    new_object.receipt_date = params[:receipt_date]
    new_object.contact_id = params[:contact_id]
    new_object.cash_bank_id = params[:cash_bank_id]
    new_object.amount = BigDecimal("0")
    new_object.save
    if new_object.save
      new_object.code = "RV-" + new_object.id.to_s
      code = ""
      if not new_object.cash_bank.code.nil?
        code = new_object.cash_bank.code.to_s + new_object.receipt_date.month.to_s + " "
      end
      new_object.no_bukti = code +  new_object.no_voucher.to_s
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if self.receipt_voucher_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end 
     if (params[:is_gbch] == false) & (params[:gbch_no].present?)
      self.errors.add(:gbch_no, "GBCH no tidak perlu di isi apabila bukan GBCH")
      return self
    elsif (params[:is_gbch] == true) & (not params[:gbch_no].present?)
      self.errors.add(:gbch_no, "GBCH no harus di isi apabila GBCH")
      return self
    end
    # self.no_bukti = params[:no_bukti]
    self.no_voucher = params[:no_voucher]
    self.is_gbch = params[:is_gbch]
    self.gbch_no = params[:gbch_no]
    self.due_date = params[:due_date]
    # self.pembulatan = BigDecimal(params[:pembulatan] || '0')  # params[:pembulatan] 
    # self.status_pembulatan = params[:status_pembulatan]
    self.biaya_bank = BigDecimal(params[:biaya_bank] || '0') # params[:biaya_bank]
    self.rate_to_idr = BigDecimal(params[:rate_to_idr] || '0')  # params[:rate_to_idr]
    self.receipt_date = params[:receipt_date]
    self.contact_id = params[:contact_id]
    self.cash_bank_id = params[:cash_bank_id]
    if self.save
      code = ""
      if not self.cash_bank.code.nil?
        code = self.cash_bank.code.to_s + " "
      end
      self.no_bukti = code +  self.no_voucher.to_s
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if self.receipt_voucher_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end 
    self.destroy
    return self
  end
  
  def update_cash_bank_amount(amount)
    cb = CashBank.find_by_id(self.cash_bank_id)
    cb.update_amount(amount)
  end
  
  def update_receivable_remaining_amount(receivable_id,amount)
    rv = Receivable.find_by_id(receivable_id)
    rv.update_remaining_amount(amount)
    rv.set_completed_receivable
  end
  
  def generate_cash_mutation(total)
      CashMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :source_code => self.code,
        :amount => total ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.confirmed_at ,  
        :cash_bank_id => self.cash_bank_id 
       ) 
  end
  
  def delete_cash_mutation
     CashMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id 
      ).each {|x| x.delete_object  }
  end
  
  def update_amount(amount)
    self.amount = amount
    self.save
  end
  
  def update_total_pph_23(amount)
    self.total_pph_23 = amount
    self.save
  end
  
  def confirm_detail
    self.receipt_voucher_details.each do |rvd|
      rcb = Receivable.find_by_id(rvd.receivable_id)
      if self.is_gbch?
        rcb.update_pending_clearence_amount(rvd.amount)
      else
         rcb.update_remaining_amount(rvd.amount * -1)
      end
      rcb.set_completed_receivable
    end
  end
  
  def unconfirm_detail
    self.receipt_voucher_details.each do |rvd|        
      rcb = Receivable.find_by_id(rvd.receivable_id)
      if self.is_gbch?
        rcb.update_pending_clearence_amount(rvd.amount * -1)
      else
        rcb.update_remaining_amount(rvd.amount)
      end
      rcb.set_completed_receivable
    end
  end
  
  def reconciled_detail
    self.receipt_voucher_details.each do |rvd|
      rcb = Receivable.find_by_id(rvd.receivable_id)
      rcb.update_remaining_amount(rvd.amount * -1)
      rcb.update_pending_clearence_amount(rvd.amount * -1)
      rcb.set_completed_receivable
    end
  end
  
  def unreconciled_detail
    self.receipt_voucher_details.each do |rvd|        
      rcb = Receivable.find_by_id(rvd.receivable_id)
      rcb.update_remaining_amount(rvd.amount)
      rcb.update_pending_clearence_amount(rvd.amount)
      rcb.set_completed_receivable
    end
  end
  
  
  
  def confirm_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end  
    if Closing.is_date_closed(self.receipt_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if self.receipt_voucher_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end 
    self.receipt_voucher_details.each do |rvd|        
      rcb = Receivable.find_by_id(rvd.receivable_id)
      if rcb.remaining_amount < rvd.amount
        self.errors.add(:generic_errors, "Remaining Amount Receivable #{rcb.source_code} lebih kecil dari jumlah amount di detail")
        return self 
      end
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    self.pembulatan = BigDecimal(params[:pembulatan] || '0')
    self.status_pembulatan = params[:status_pembulatan]
    if self.save
      self.confirm_detail
      if not self.is_gbch?
        biaya_pembulatan = 0 
        puts "The biaya_pembulatan is nil before depoy" if biaya_pembulatan.nil?
        
       if self.status_pembulatan == NORMAL_BALANCE[:credit]
          biaya_pembulatan = self.pembulatan 
        else
          biaya_pembulatan = self.pembulatan * -1
        end
        total = self.amount - self.total_pph_23 - self.biaya_bank + biaya_pembulatan
        self.generate_cash_mutation(total)
        self.update_cash_bank_amount(total)
        AccountingService::CreateReceiptVoucherJournal.create_confirmation_journal(self)
      end
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if (self.is_gbch == true) & (self.is_reconciled == true)
      self.errors.add(:generic_errors, "belum di unreconcile")
      return self 
    end
    if Closing.is_date_closed(self.receipt_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if not self.is_gbch
      biaya_pembulatan = 0 
        if self.status_pembulatan == NORMAL_BALANCE[:credit]
          biaya_pembulatan = self.pembulatan 
        else
          biaya_pembulatan = self.pembulatan * -1
        end
        total = self.amount - self.total_pph_23 - self.biaya_bank + biaya_pembulatan
      if total > self.cash_bank.amount 
        self.errors.add(:generic_errors, "Dana tidak mencukupi")
        return self 
      end
    end
   
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
      self.unconfirm_detail
      if not self.is_gbch?
        self.delete_cash_mutation
        biaya_pembulatan = 0 
        if self.status_pembulatan == NORMAL_BALANCE[:credit]
          biaya_pembulatan = self.pembulatan 
        else
          biaya_pembulatan = self.pembulatan * -1
        end
        total = self.amount - self.total_pph_23 - self.biaya_bank + biaya_pembulatan
        self.update_cash_bank_amount(total * -1)
        AccountingService::CreateReceiptVoucherJournal.undo_create_confirmation_journal(self)
      end
    end
    return self
  end
  
  def reconcile_object(params)
    if not self.is_gbch?
      self.errors.add(:generic_errors, "bukan gbch")
      return self 
    end
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if self.is_reconciled?
      self.errors.add(:generic_errors, "Sudah di reconcile")
      return self 
    end
    self.receipt_voucher_details.each do |rvd|        
      rcb = Receivable.find_by_id(rvd.receivable_id)
      if rcb.remaining_amount < rvd.amount
        self.errors.add(:generic_errors, "Remaining Amount Receivable #{rcb.source_code} lebih kecil dari jumlah amount di detail")
        return self 
      end
    end
    self.is_reconciled = true
    self.reconciliation_date = params[:reconciliation_date]
    if Closing.is_date_closed(self.reconciliation_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if self.save
      self.reconciled_detail
      biaya_pembulatan = 0 
      if self.status_pembulatan == NORMAL_BALANCE[:credit]
        biaya_pembulatan = self.pembulatan * -1
      else
        biaya_pembulatan = self.pembulatan
      end
      total = self.amount - (self.total_pph_23 + self.biaya_bank + biaya_pembulatan)
      self.generate_cash_mutation(total)
      self.update_cash_bank_amount(total)
      AccountingService::CreateReceiptVoucherJournal.create_confirmation_journal(self)
    end
    return self
  end
  
  def unreconcile_object
    if not self.is_gbch?
      self.errors.add(:generic_errors, "bukan gbch")
      return self 
    end
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if not self.is_reconciled?
      self.errors.add(:generic_errors, "belum di reconcile")
      return self 
    end
    biaya_pembulatan = 0 
    if self.status_pembulatan == NORMAL_BALANCE[:credit]
      biaya_pembulatan = self.pembulatan * -1
    else
      biaya_pembulatan = self.pembulatan
    end
    total = self.amount - (self.total_pph_23 + self.biaya_bank + biaya_pembulatan)
    if total > self.cash_bank.amount 
      self.errors.add(:generic_errors, "Dana tidak mencukupi")
      return self 
    end
    if Closing.is_date_closed(self.reconciliation_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    self.is_reconciled = false
    self.reconciliation_date = nil
    if self.save
      self.unreconciled_detail
      self.delete_cash_mutation
      biaya_pembulatan = 0 
      if self.status_pembulatan == NORMAL_BALANCE[:credit]
        biaya_pembulatan = self.pembulatan * -1
      else
        biaya_pembulatan = self.pembulatan
      end
      total = self.amount - (self.total_pph_23 + self.biaya_bank + biaya_pembulatan)
      self.update_cash_bank_amount(total * -1)
      AccountingService::CreateReceiptVoucherJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
  
end
