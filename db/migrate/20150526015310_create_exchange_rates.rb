class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
     
      t.timestamps
    end
  end
end
