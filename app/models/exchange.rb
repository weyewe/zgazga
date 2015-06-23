class Exchange < ActiveRecord::Base
   validates_presence_of :name
   validates_uniqueness_of :name
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    if new_object.save
      list_account_id = Account.create_object_from_exchange(new_object)
#       0 =  account_receivable  | 1 = gbch_receivable | 2 = account_payable | 3 = gbch_payable
      new_object.account_receivable_id = list_account_id[0]
      new_object.gbch_receivable_id = list_account_id[1]
      new_object.account_payable_id = list_account_id[2]
      new_object.gbch_payable_id = list_account_id[3]
      new_object.save
    end
    return new_object
  end
  
  def self.create_object_for_base_exchange
    new_object  = self.new
    new_object.name = "IDR"
    new_object.description = ""
    new_object.is_base = true
    new_object.save
    list_account_id = Account.create_object_from_exchange(new_object)
#       0 =  account_receivable  | 1 = gbch_receivable | 2 = account_payable | 3 = gbch_payable
      new_object.account_receivable_id = list_account_id[0]
      new_object.gbch_receivable_id = list_account_id[1]
      new_object.account_payable_id = list_account_id[2]
      new_object.gbch_payable_id = list_account_id[3]
      new_object.save

    return new_object
  end
  
  def self.active_objects
    self
  end
  
  def update_object( params ) 
    if self.is_base == true
      self.errors.add(:generic_errors, "Tidak dapat mengedit base currency")
      return self
    end
    self.name = params[:name]
    self.description = params[:description]    
    self.save
    return self
  end
  
  def delete_object
    if self.is_base == true
      self.errors.add(:generic_errors, "Tidak dapat menghapus base currency")
      return self
    end
    
    if TransactionDataDetail.where(:account_id => self.account_payable_id).count > 0 or 
      TransactionDataDetail.where(:account_id => self.account_receivable_id).count > 0 or 
      TransactionDataDetail.where(:account_id => self.gbch_receivable_id).count > 0 or 
      TransactionDataDetail.where(:account_id => self.gbch_payable_id).count > 0 
      self.errors.add(:generic_errors, "Currency sudah terpakai")
    end
    
    self.destroy
    return self
  end
  
end
