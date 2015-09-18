class AddContactIdToTransactionDataDetails < ActiveRecord::Migration
  def change
    add_column :transaction_data_details, :contact_id, :integer
  end
end
