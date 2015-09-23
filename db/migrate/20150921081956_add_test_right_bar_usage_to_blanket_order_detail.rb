class AddTestRightBarUsageToBlanketOrderDetail < ActiveRecord::Migration
  def change
    add_column :blanket_order_details, :test_right_bar_usage, :integer
  end
end
