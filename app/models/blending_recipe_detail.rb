class BlendingRecipeDetail < ActiveRecord::Base
    
  belongs_to :blending_recipe
  validates_presence_of :blending_recipe_id
  validates_presence_of :blending_item_id
  validate :valid_blending_item_id
  
  def self.active_objects
    self
  end
  
  
  def valid_blending_recipe
    return if  blending_recipe_id.nil?
    br = BlendingRecipe.find_by_id blending_recipe_id
    if br.nil? 
      self.errors.add(:blending_recipe_id, "Harus ada Blending Recipe Id")
      return self 
    end
  end 
  
  def valid_blending_item_id
    return if  blending_item_id.nil?
    item = Item.find_by_id blending_item_id
    if item.nil? 
      self.errors.add(:blending_item_id, "Harus ada Blending Item Id")
      return self 
    end
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.blending_recipe_id = params[:blending_recipe_id]
    new_object.blending_item_id = params[:blending_item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.blending_recipe_id = params[:blending_recipe_id]
    self.blending_item_id = params[:blending_item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end  
  
end
