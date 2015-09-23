class AddTestLeftBarUsageToBlanketOrderDetail < ActiveRecord::Migration
  def change
    add_column :blanket_order_details, :test_left_bar_usage, :integer
  end
end
