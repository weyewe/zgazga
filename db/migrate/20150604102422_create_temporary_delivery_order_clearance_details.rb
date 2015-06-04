class CreateTemporaryDeliveryOrderClearanceDetails < ActiveRecord::Migration
  def change
    create_table :temporary_delivery_order_clearance_details do |t|
      t.string :code
      t.integer :temporary_delivery_order_clearence_id
      t.integer :temporary_delivery_order_detail_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :waste_cogs, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :selling_price, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
