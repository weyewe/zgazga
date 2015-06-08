class CreateTransactionDataNonBaseExchanges < ActiveRecord::Migration
  def change
    create_table :transaction_data_non_base_exchanges do |t|
      t.integer :transaction_data_id
      t.integer :exchange_id 

      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      
      t.timestamps
    end
  end
end
