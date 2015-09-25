class AddDescriptionToPaymentRequestDetail < ActiveRecord::Migration
  def change
    add_column :payment_request_details, :description, :string
  end
end
