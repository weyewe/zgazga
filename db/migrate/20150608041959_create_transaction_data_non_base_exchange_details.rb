class CreateTransactionDataNonBaseExchangeDetails < ActiveRecord::Migration
  
  def change
    create_table :transaction_data_non_base_exchange_details do |t|
      t.integer :transaction_data_detail_id 
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
