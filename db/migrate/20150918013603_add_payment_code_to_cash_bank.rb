class AddPaymentCodeToCashBank < ActiveRecord::Migration
  def change
    add_column :cash_banks, :payment_code, :string
  end
end
