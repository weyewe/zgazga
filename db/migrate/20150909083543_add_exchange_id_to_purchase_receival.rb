class AddExchangeIdToPurchaseReceival < ActiveRecord::Migration
  def change
    add_column :purchase_receivals, :exchange_id, :integer
  end
end
