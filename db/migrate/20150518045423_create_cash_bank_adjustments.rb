class CreateCashBankAdjustments < ActiveRecord::Migration
  def change
    create_table :cash_bank_adjustments do |t|
      t.integer :cash_bank_id
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :exchange_rate_amount ,:default        => 0,  :precision => 18, :scale => 11
      t.integer :exchange_rate_id
      t.integer :status , :default        => ADJUSTMENT_STATUS[:addition]
      
      t.datetime :adjustment_date 
      
      t.datetime :confirmed_at 
      t.boolean :is_confirmed, :default => false 
      t.text :description
      t.string :code 

      t.timestamps
    end
  end
end
