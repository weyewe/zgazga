class CoreBuilder < ActiveRecord::Base
  acts_as :item
  
  belongs_to :contact
  belongs_to :machine
  
  validates_presence_of :uom_id
  validates_presence_of :machine_id
  validates_uniqueness_of :sku
  validate :valid_uom_id
  validate :valid_machine_id
  validate :valid_core_builder_type
  
  def valid_uom_id
    return if uom_id.nil? 
    uom = Uom.find_by_id(uom_id)
    if uom.nil? 
      self.errors.add(:uom_id, "Harus ada uom_id")
      return self
    end
  end
  
  def valid_core_builder_type
    return if core_builder_type_case.nil?
    if not [CORE_BUILDER_TYPE[:hollow],CORE_BUILDER_TYPE[:shaft],CORE_BUILDER_TYPE[:none]].include?( core_builder_type_case) 
      self.errors.add(:core_builder_type_case, "CoreBuilder Type harus ada")
      return self 
    end
  end
  
  def valid_machine_id
    return if machine_id.nil? 
    machine = Machine.find_by_id(machine_id)
    if machine.nil? 
      self.errors.add(:machine_id, "Harus ada machine_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def used_core_item
    CoreBuilder.find_by_id(self.used_core_item_id)
  end
  
  def new_core_item
    CoreBuilder.find_by_id(self.new_core_item_id)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.sku = params[:sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.item_type_id = ItemType.find_by_name("Core").id
    new_object.uom_id = params[:uom_id]
    new_object.minimum_amount =  BigDecimal( params[:minimum_amount] || '0') 
    new_object.selling_price =  BigDecimal( params[:selling_price] || '0') 
    new_object.exchange_id = params[:exchange_id]
    new_object.price_list =  BigDecimal( params[:price_list] || '0') 
    new_object.core_builder_type_case = params[:core_builder_type_case]
    new_object.machine_id = params[:machine_id]
    new_object.cd = BigDecimal( params[:cd] || '0') 
    new_object.tl = BigDecimal( params[:tl] || '0') 
    if new_object.save
      # create used core item
      used_core = self.new
      used_core.sku = new_object.sku.to_s +"U"
      used_core.name = new_object.name
      used_core.description = new_object.description
      used_core.item_type_id = ItemType.find_by_name("Core").id
      used_core.uom_id = new_object.uom_id
      used_core.minimum_amount =  new_object.minimum_amount
      used_core.selling_price =  new_object.selling_price
      used_core.exchange_id = new_object.exchange_id
      used_core.price_list =  new_object.price_list
      used_core.core_builder_type_case = new_object.core_builder_type_case
      used_core.machine_id = new_object.machine_id
      used_core.cd = new_object.cd
      used_core.tl = new_object.tl
      used_core.save
      # create new core item
      new_core = self.new
      new_core.sku = new_object.sku.to_s +"N"
      new_core.name = new_object.name
      new_core.description = new_object.description
      new_core.item_type_id = ItemType.find_by_name("Core").id
      new_core.uom_id = new_object.uom_id
      new_core.minimum_amount =  new_object.minimum_amount
      new_core.selling_price =  new_object.selling_price
      new_core.exchange_id = new_object.exchange_id
      new_core.price_list =  new_object.price_list
      new_core.core_builder_type_case = new_object.core_builder_type_case
      new_core.machine_id = new_object.machine_id
      new_core.cd = new_object.cd
      new_core.tl = new_object.tl
      new_core.save
      
      new_object.sku_used_core = used_core.sku
      new_object.sku_new_core = new_core.sku
      new_object.used_core_item_id = used_core.item.id
      new_object.new_core_item_id = new_core_item.item_id
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.sku = params[:sku]
    self.name = params[:name]
    self.description = params[:description]
    self.uom_id = params[:uom_id]
    self.minimum_amount =  BigDecimal( params[:minimum_amount] || '0') 
    self.selling_price =  BigDecimal( params[:selling_price] || '0') 
    self.exchange_id = params[:exchange_id]
    self.price_list =  BigDecimal( params[:price_list] || '0') 
    self.core_builder_type_case = params[:core_builder_type_case]
    self.machine_id = params[:machine_id]
    self.cd = BigDecimal(params[:cd] || '0')
    self.tl = BigDecimal(params[:tl] || '0')
    if self.save
      self.used_core_item.name
      
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
    
    
end
