class CreateTemporaryDeliveryOrderClearances < ActiveRecord::Migration
  def change
    create_table :temporary_delivery_order_clearances do |t|
      t.string :code
      t.integer :temporary_delivery_order_id
      t.datetime :clearance_date
      t.decimal :total_waste_cogs, :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_waste , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
