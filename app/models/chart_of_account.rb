class ChartOfAccount < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_presence_of :code 
  def self.active_objects
    self
  end

  
  def self.create_legacy
#     account receivable
    new_object = self.new
    new_object.code = ACCOUNT_LEGACY_CODE[:account_receivable]
    new_object.name = "Account Receivable"
    new_object.group = ACCOUNT_GROUP[:asset]
    new_object.level = 4
#     new_object.parent_id = ar_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = false
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:account_receivable]
    new_object.save
    
#   account payable
    new_object = self.new
    new_object.code = ACCOUNT_LEGACY_CODE[:account_payable]
    new_object.name = "Account Payable"
    new_object.group = ACCOUNT_GROUP[:asset]
    new_object.level = 4
#     new_object.parent_id = ar_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:account_payable]
    new_object.save
    
#     gbch_receivable
    new_object = self.new
    new_object.code = ACCOUNT_LEGACY_CODE[:gbch_receivable]
    new_object.name = "GBCH Receivable"
    new_object.group = ACCOUNT_GROUP[:liability]
    new_object.level = 4
#     new_object.parent_id = ar_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:gbch_receivable]
    new_object.save
    
#     gbch_payable
    new_object = self.new
    new_object.code =  ACCOUNT_LEGACY_CODE[:gbch_payable]
    new_object.name = "GBCH Payable" 
    new_object.group = ACCOUNT_GROUP[:liability]
    new_object.level = 4
#     new_object.parent_id = ar_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:gbch_payable]
    new_object.save
    
    
  end
  
  def generate_account_code(params)
    parent_code = ChartOfAccount.where(:id => params[:parent_id]).first.code
    return parent_code + params[:exchange_id].to_s
  end
  
  def self.create_object_from_exchange(exchange)
#     create ar
    ar_account = ChartOfAccount.where(:legacy_code =>ACCOUNT_LEGACY_CODE[:account_receivable]).first
    new_object = self.new
    new_object.code = new_object.generate_account_code(:exchange_id => exchange.id,:parent_id => ar_account.id)
    new_object.name = "Account Receivable" + exchange.name.to_s
    new_object.group = ACCOUNT_GROUP[:asset]
    new_object.level = ar_account.level + 1
    new_object.parent_id = ar_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:account_receivable] + exchange.id.to_s
    new_object.save
    
#     create ar_gbch
    ar_gbch_account = ChartOfAccount.where(:legacy_code =>ACCOUNT_LEGACY_CODE[:gbch_receivable]).first
    new_object = self.new
    new_object.code = new_object.generate_account_code(:exchange_id => exchange.id,:parent_id => ar_gbch_account.id)
    new_object.name = "GBCH Receivable" + exchange.name.to_s
    new_object.group = ACCOUNT_GROUP[:liability]
    new_object.level = ar_gbch_account.level + 1 
    new_object.parent_id = ar_gbch_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:gbch_receivable] + exchange.id.to_s
    new_object.save
    
#     create ap
    ap_account = ChartOfAccount.where(:legacy_code =>ACCOUNT_LEGACY_CODE[:account_payable]).first
    new_object = self.new
    new_object.code = new_object.generate_account_code(:exchange_id => exchange.id,:parent_id => ap_account.id)
    new_object.name = "Account Payable" + exchange.name.to_s
    new_object.group = ACCOUNT_GROUP[:liability]
    new_object.level = ap_account.level + 1
    new_object.parent_id = ap_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:account_payable] + exchange.id.to_s
    new_object.save
    
#     create gbch_payable
    ap_gbch_payable_account = ChartOfAccount.where(:legacy_code =>ACCOUNT_LEGACY_CODE[:gbch_payable]).first
    new_object = self.new
    new_object.code = new_object.generate_account_code(:exchange_id => exchange.id,:parent_id => ap_gbch_payable_account.id)
    new_object.name = "GBCH Receivable" + exchange.name.to_s
    new_object.group = ACCOUNT_GROUP[:asset]
    new_object.level = ap_gbch_payable_account.level + 1
    new_object.parent_id = ap_gbch_payable_account.id
    new_object.is_cash_bank_account = false
    new_object.is_leaf = true
    new_object.legacy_code = ACCOUNT_LEGACY_CODE[:gbch_payable] + exchange.id.to_s
    new_object.save
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.code = params[:code]
    new_object.name = params[:name]
    new_object.group = params[:group]
    new_object.level = params[:level]
    new_object.parent_id = params[:parent_id]
    new_object.is_leaf = params[:is_leaf]   
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.code = params[:code]
    self.name = params[:name]
    self.group = params[:group]
    self.level = params[:level]
    self.parent_id = params[:parent_id]
    self.is_leaf = params[:is_leaf]  
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
end
