class ItemType < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_uniqueness_of :name
  belongs_to :account 
  
  
  validate :valid_account
  
  def valid_account
    
    return if account_id.nil? 
    account = Account.find_by_id(account_id)
    if account.nil? 
      self.errors.add(:account_id, "Harus ada account_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.account_id = params[:account_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.description = params[:description]
    self.account_id = params[:account_id]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
end
