class AddNoBuktiToTransactionDataDetail < ActiveRecord::Migration
  def change
    add_column :transaction_data_details, :no_bukti, :string
  end
end
