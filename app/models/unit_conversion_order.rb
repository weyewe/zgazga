class UnitConversionOrder < ActiveRecord::Base
    belongs_to :unit_conversion
    belongs_to :warehouse
    validates_presence_of :warehouse_id
    validates_presence_of :unit_conversion_id
    validates_presence_of :conversion_date
    validate :valid_warehouse_id
    validate :valid_unit_conversion_id
    
    def valid_warehouse_id
      return if warehouse_id.nil?
      
      wh = Warehouse.find_by_id warehouse_id
      
      if wh.nil? 
        self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
        return self 
      end
    end
    
    def valid_unit_conversion_id
      return if unit_conversion_id.nil?
      
      br = UnitConversion.find_by_id unit_conversion_id
      
      if br.nil? 
        self.errors.add(:unit_conversion_id, "Harus ada UnitConversion Id")
        return self 
      end
    end
    
    def self.active_objects
      return self
    end
    
    def self.create_object(params)
      new_object = self.new
      new_object.unit_conversion_id = params[:unit_conversion_id]
      new_object.warehouse_id = params[:warehouse_id]
      new_object.description = params[:description]
      new_object.conversion_date = params[:conversion_date]
      new_object.code = params[:code]
      if new_object.save
      end
      return new_object
    end
    
    def update_object(params)
      if self.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
      self.unit_conversion_id = params[:unit_conversion_id]
      self.warehouse_id = params[:warehouse_id]
      self.description = params[:description]
      self.conversion_date = params[:conversion_date]
      self.code = params[:code]
      if self.save
      end
      return self
    end
    
    def delete_object
      self.destroy
      return self
    end
    
    def confirm_object(params)
      if self.is_confirmed?
        self.errors.add(:generic_errors, "Sudah di konfirmasi")
        return self 
      end
      if params[:confirmed_at].nil?
        self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
        return self 
      end  
      # check source amount
      self.unit_conversion.unit_conversion_details.each do |brd|
         item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => brd.item_id)      
        if brd.amount > item_in_warehouse.amount
          self.errors.add(:generic_errors, "Stock quantity untuk Source items #{brd.item.name} tidak cukup")
          return self 
        end        
      end
      
      if Closing.is_date_closed(self.conversion_date).count > 0 
        self.errors.add(:generic_errors, "Period sudah di closing")
        return self 
      end
    
      self.is_confirmed = true
      self.confirmed_at = params[:confirmed_at]
      if self.save
        self.update_conversion_work_order_confirm
      end
      return self
    end
    
    def unconfirm_object
      if not self.is_confirmed?
        self.errors.add(:generic_errors, "belum di konfirmasi")
        return self 
      end
      item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => self.unit_conversion.target_item_id)      
      if self.unit_conversion.target_amount > item_in_warehouse.amount
        self.errors.add(:generic_errors, "Stock quantity untuk Target item tidak cukup")
        return self 
      end      
      
      if Closing.is_date_closed(self.conversion_date).count > 0 
        self.errors.add(:generic_errors, "Period sudah di closing")
        return self 
      end
      
      self.is_confirmed = false
      self.confirmed_at = nil
      if self.save
        self.update_conversion_work_order_unconfirm
      end
      return self
    end
    
    def update_conversion_work_order_confirm
      total_cost = 0
      # deduce source item amount
      self.unit_conversion.unit_conversion_details.each do |brd|
        total_cost += (brd.amount * brd.item.avg_price).round(2)
        item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => brd.item_id)      
        new_stock_mutation = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => brd.amount ,  
          :status => ADJUSTMENT_STATUS[:deduction],  
          :mutation_date => self.conversion_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => brd.item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      end
      
      # update avg_price target_item
      item_price = (total_cost / self.unit_conversion.target_amount).round(2)
      self.unit_conversion.target_item.calculate_avg_price(
        :added_amount => self.unit_conversion.target_amount,
        :added_avg_price => item_price)
        
      # add target_item
      item_in_warehouse = WarehouseItem.find_or_create_object(
          :warehouse_id => self.warehouse_id,
          :item_id => self.unit_conversion.target_item_id)      
        new_stock_mutation = StockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :amount => self.unit_conversion.target_amount ,  
          :status => ADJUSTMENT_STATUS[:addition],  
          :mutation_date => self.conversion_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => self.unit_conversion.target_item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      
      # create journal
      AccountingService::CreateUnitConversionOrderJournal.create_confirmation_journal(self,total_cost)
    end
    
    def update_conversion_work_order_unconfirm
      self.unit_conversion.unit_conversion_details.each do |brd|
        stock_mutation = StockMutation.where(
            :source_class => self.class.to_s, 
            :source_id => self.id,
            :item_id => brd.item_id
            ).first
        stock_mutation.reverse_stock_mutate_object  
        stock_mutation.delete_object
      end
      target_stock_mutation =  StockMutation.where(
            :source_class => self.class.to_s, 
            :source_id => self.id,
            :item_id => self.unit_conversion.target_item_id
            ).first
      target_stock_mutation.reverse_stock_mutate_object  
      target_stock_mutation.delete_object
      AccountingService::CreateUnitConversionOrderJournal.undo_create_confirmation_journal(self)
    end
end
