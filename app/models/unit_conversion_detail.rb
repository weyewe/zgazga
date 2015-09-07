class UnitConversionDetail < ActiveRecord::Base
    
  belongs_to :unit_conversion
  belongs_to :item
  validates_presence_of :unit_conversion_id
  validates_presence_of :item_id
  validate :valid_blending_item_id
  
  def self.active_objects
    self
  end
  
  def valid_unit_conversion
    return if  unit_conversion_id.nil?
    br = UnitConversion.find_by_id unit_conversion_id
    if br.nil? 
      self.errors.add(:unit_conversion_id, "Harus ada UnitConversion Id")
      return self 
    end
  end 
  
  def valid_blending_item_id
    return if item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item Id")
      return self 
    end
  end
  
  def self.create_object(params)
    new_object = self.new
    if UnitConversionOrder.where(:unit_conversion_id => params[:unit_conversion_id]).count > 0
      new_object.errors.add(:generic_errors,"Sudah digunakan di UnitConversionOrder")
      return new_object
    end
    new_object.unit_conversion_id = params[:unit_conversion_id]
    new_object.item_id = params[:item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if UnitConversionOrder.where(:unit_conversion_id => self.unit_conversion_id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di UnitConversionOrder")
      return self
    end
    self.item_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    if UnitConversionOrder.where(:unit_conversion_id => self.unit_conversion_id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di UnitConversionOrder")
      return self
    end
    self.destroy
    return self
  end  
end
