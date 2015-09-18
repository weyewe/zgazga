class AddNoVoucherToPaymentVoucher < ActiveRecord::Migration
  def change
    add_column :payment_vouchers, :no_voucher, :string
  end
end
