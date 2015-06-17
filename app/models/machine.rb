class Machine < ActiveRecord::Base
    
  validates_presence_of :name
  validates_uniqueness_of :code
  validates_presence_of :code 
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.code = params[:code]
    new_object.description = params[:description]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.code = params[:code]
    self.description = params[:description]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
end
