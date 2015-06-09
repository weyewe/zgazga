class Closing < ActiveRecord::Base
  has_many :valid_combs
  validates_presence_of :period
  validates_presence_of :year_period
  validates_presence_of :beginning_period
  validates_presence_of :end_date_period
  validates_presence_of :is_year
  
  validate :end_period_must_be_later_than_any_start_period
  
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
        
      }.count != 0 
        self.errors.add(:end_period, "Sudah ada closing yang tanggal mulai lebih akhir daripada tanggal end_period anda")
        return self 
      end
      
    else
      if Closing.where{
        ( beginning_period.gte  current_end_period ) | 
        ( end_date_period.gte current_end_period )
      }.count != 0 
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
    new_object.is_year = params[:is_year]
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    self.period = params[:period]
    self.year_period = params[:year_period]
    self.beginning_period = params[:beginning_period]
    self.end_date_period = params[:end_date_period]
    self.is_year = params[:is_year]
    if self.save
    end
    return self
  end
  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    
    self.is_confirmed =false
    self.confirmed_at = nil
    if self.save
      self.generate_valid_combs
      self.generate_valid_combs_for_non_children
    end  
  end
  
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def generate_valid_combs
    start_transaction = start_period
    end_transaction = end_period
    leaves_account = Account.all_ledger_accounts
    leaves_account_id_list = leaves_account.map{|x| x.id }
    
    leaves_account.each do |leaf_account|
      valid_comb_amount = BigDecimal("0")
      
      total_debit = BigDecimal("0")
      total_credit = BigDecimal("0")
      
      if not start_transaction.nil?
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")

        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.gte start_transaction) & 
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
      else
        total_debit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:debit])
        }.sum("amount")

        total_credit = TransactionDataDetail.joins(:transaction_data).where{
          ( transaction_data.transaction_datetime.lt end_transaction) & 
          ( account_id.eq leaf_account.id ) & 
          ( entry_case.eq NORMAL_BALANCE[:credit])
        }.sum("amount")
      end
      
      if leaf_account.normal_balance == NORMAL_BALANCE[:debit]
        valid_comb_amount = total_debit - total_credit
      else
        valid_comb_amount = total_credit -  total_debit
      end
      
      final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, leaf_account )
      
      entry_case = leaf_account.normal_balance  
      
      if final_valid_comb_amount < BigDecimal("0")
        entry_case = NORMAL_BALANCE[:debit] if leaf_account.normal_balance == NORMAL_BALANCE[:credit] 
        entry_case = NORMAL_BALANCE[:credit] if leaf_account.normal_balance == NORMAL_BALANCE[:debit] 
      end
      
      puts " #{leaf_account.name} (#{leaf_account.code}) :: #{valid_comb_amount} "
      
      valid_comb = ValidComb.create_object(
        :account_id => leaf_account.id,
        :closing_id => self.id,
        :amount => final_valid_comb_amount.abs,
        :entry_case => entry_case
      )
      
    end
    
    parent_id_list = leaves_account.map{|x| x.parent_id }.uniq
    
    if parent_id_list.length != 0
      generate_parent_valid_combs(  parent_id_list ) 
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
      
      
      final_valid_comb_amount = valid_comb_amount + ValidComb.previous_closing_valid_comb_amount( previous_closing, node )
      
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
