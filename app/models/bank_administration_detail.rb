class BankAdministrationDetail < ActiveRecord::Base
  belongs_to :bank_administration
  belongs_to :account
  
  validate :valid_bank_administration
  validate :valid_account
  validate :valid_status
  validate :valid_amount
  
  def valid_status
    return if status.nil?
    if not [1,2].include?( status.to_i ) 
      self.errors.add(:status, "Status harus ada")
      return self 
    end
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_bank_administration
    return if  bank_administration_id.nil?
    ba = BankAdministration.find_by_id bank_administration_id
    if ba.nil? 
      self.errors.add(:bank_administration_id, "Harus ada BankAdministration id")
      return self 
    end
  end 
  
  def valid_account
    return if  account_id.nil?
    ac = Account.find_by_id account_id
    if ac.nil? 
      self.errors.add(:account_id, "Harus ada Account id")
      return self 
    end
  end 
    
  def self.create_object(params)
    new_object = self.new 
    new_object.bank_administration_id = params[:bank_administration_id]
    new_object.account_id = params[:account_id]
    new_object.description = params[:description]
    new_object.status = params[:status]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    self.bank_administration_id = params[:bank_administration_id]
    self.account_id = params[:account_id]
    self.description = params[:description]
    self.status = params[:status]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
      calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    self.destroy
    calculateTotalAmount
    return self
  end
  
  def calculateTotalAmount
    amount = 0
    BankAdministrationDetail.where(:bank_administration_id =>bank_administration_id).each do |bad|
      if bad.status = NORMAL_BALANCE[:credit]
        amount += bad.amount 
      else
        amount += bad.amount * -1
      end
    end
    bank_administration = BankAdministration.find_by_id(bank_administration_id)
    bank_administration.amount = amount 
    bank_administration.save
  end
  
  
end
