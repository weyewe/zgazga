class PurchaseRequestDetail < ActiveRecord::Base
  belongs_to :purchase_request
  validates_presence_of :name
  validate :valid_amount
  validate :valid_purchase_request
  def self.active_objects
    self
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_purchase_request
    return if  purchase_request_id.nil?
    sq = PurchaseRequest.find_by_id purchase_request_id
    if sq.nil? 
      self.errors.add(:purchase_request_id, "Harus ada PurchaseRequestId")
      return self 
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    purchase_request = PurchaseRequest.find_by_id(params[:purchase_request_id])
    if not purchase_request.nil?
      if purchase_request.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.purchase_request_id = params[:purchase_request_id]
    new_object.name = params[:name]
    new_object.uom = params[:uom]
    new_object.description = params[:description]
    new_object.category = params[:category]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
      new_object.code = "RQD-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.purchase_request.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.name = params[:name]
    self.uom = params[:uom]
    self.description = params[:description]
    self.category = params[:category]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
      self.save
    end
    return self
  end
  
  def delete_object
    if self.purchase_request.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
end
