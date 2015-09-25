class AddDiscountToPurchaseOrderDetail < ActiveRecord::Migration
  def change
    add_column :purchase_order_details, :discount, :decimal,:default        => 0,   :precision => 18, :scale => 11
  end
end
