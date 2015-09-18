class AddNoVoucherToReceiptVoucher < ActiveRecord::Migration
  def change
    add_column :receipt_vouchers, :no_voucher, :string
  end
end
