class ItemType < ActiveRecord::Base
  
  validates_presence_of :name 
  validates_uniqueness_of :name
  validate :valid_chart_of_account
  
  def valid_chart_of_account
    
    return if chart_of_account_id.nil? 
    chart_of_account = ChartOfAccount.find_by_id(chart_of_account_id)
    if chart_of_account.nil? 
      self.errors.add(:chart_of_account_id, "Harus ada chart_of_account_id")
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
    new_object.chart_of_account_id = params[:chart_of_account_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.description = params[:description]
    self.chart_of_account_id = params[:chart_of_account_id]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
end
