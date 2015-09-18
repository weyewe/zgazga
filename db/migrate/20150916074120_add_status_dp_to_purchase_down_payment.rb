class AddStatusDpToPurchaseDownPayment < ActiveRecord::Migration
  def change
    add_column :purchase_down_payments, :status_dp, :integer
  end
end
