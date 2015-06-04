class Item < ActiveRecord::Base
  belongs_to :item_type
  validates_presence_of :sku
  validates_uniqueness_of :sku
  validates_presence_of :name
  validates_presence_of :item_type_id
  
  validate :valid_uom_id
  validate :valid_item_type_id
  validate :valid_exchange_id
  validate :valid_selling_price_and_price_list_and_minimum_amount
  
  def valid_uom_id
    return if uom_id.nil? 
    uom = Uom.find_by_id(uom_id)
    if uom.nil? 
      self.errors.add(:uom_id, "Harus ada uom_id")
      return self
    end
  end
  
  def update_amount(amount)
    self.amount += amount
    self.save
  end
  
  def update_pending_receival(amount)
    self.pending_receival += amount
    self.save
  end
  
  def update_pending_delivery(amount)
    self.pending_delivery += amount
    self.save
  end
  
  def update_virtual(amount)
    self.virtual += amount
    self.save
  end
  
  def calculate_avg_price(params)
    original_amount = self.amount + self.virtual
    original_avg_price = self.avg_price
    avg_price = 0 
    if (original_amount + params[:added_amount]) > 0 
      a = original_amount * original_avg_price
      b = params[:added_amount] * params[:added_avg_price]
      c = original_amount + params[:added_amount]
      avg_price = (
          (a+b)/c
        )
    end
    self.avg_price = avg_price
    self.save  
    return self
  end
  
  def valid_item_type_id
    return if item_type_id.nil?
    item_type = ItemType.find_by_id(item_type_id)
    if item_type.nil? 
      self.errors.add(:item_type_id, "Harus ada item_type_id")
      return self
    end
  end
  
  def valid_exchange_id
    return if exchange_id.nil? 
    exchange = Exchange.find_by_id(exchange_id)
    if exchange.nil? 
      self.errors.add(:exchange_id, "Harus ada currency_id")
      return self
    end
  end
  
  def valid_selling_price_and_price_list_and_minimum_amount
    return if selling_price.nil? or price_list.nil? or minimum_amount.nil?
    
    if selling_price <= BigDecimal("0")
      self.errors.add(:selling_price, "Harus lebih besar dari 0")
      return self
    end
    
    if price_list <= BigDecimal("0")
      self.errors.add(:price_list, "Harus lebih besar dari 0")
      return self
    end
    
    if minimum_amount <= BigDecimal("0")
      self.errors.add(:minimum_amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.item_type_id = params[:item_type_id]
    new_object.sub_type_id = params[:sub_type_id]
    new_object.sku = params[:sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.is_tradeable = params[:is_tradeable]
    new_object.uom_id = params[:uom_id]
#     new_object.amount = params[:amount]
    new_object.minimum_amount = params[:minimum_amount]
    new_object.selling_price = params[:selling_price]
    new_object.exchange_id = params[:exchange_id]
    new_object.price_list = params[:price_list]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.item_type_id = params[:item_type_id]
    self.sub_type_id = params[:sub_type_id]
    self.sku = params[:sku]
    self.name = params[:name]
    self.description = params[:description]
    self.is_tradeable = params[:is_tradeable]
    self.uom_id = params[:uom_id]
#     self.amount = params[:amount]
    self.minimum_amount = params[:minimum_amount]
    self.selling_price = params[:selling_price]
    self.exchange_id = params[:exchange_id]
    self.price_list = params[:price_list]
    self.save
    return self
  end
  
  def delete_object
    self.destroy
  end
  
  
end
