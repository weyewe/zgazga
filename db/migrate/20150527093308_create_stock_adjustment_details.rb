class CreateStockAdjustmentDetails < ActiveRecord::Migration
  def change
    create_table :stock_adjustment_details do |t|     
      t.integer :stock_adjustment_id
      t.integer :item_id
      t.string  :code
      t.integer :status , :default => ADJUSTMENT_STATUS[:addition]
      t.decimal  :amount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal  :price,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
