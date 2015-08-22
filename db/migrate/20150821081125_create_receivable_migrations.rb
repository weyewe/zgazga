class CreateReceivableMigrations < ActiveRecord::Migration
  def change
    create_table :receivable_migrations do |t|

      t.string :nomor_surat
      t.integer :contact_id
      t.integer :exchange_id 
      t.decimal :amount_base_exchange,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :amount_foreign_exchange,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :amount_receivable,  :default => 0,  :precision => 14, :scale => 2
      
      t.decimal :exchange_rate_amount, :default => 0 ,  :precision => 18, :scale => 11
   
      
      
      t.datetime  :invoice_date
      t.datetime  :tukar_faktur_date
      t.timestamps
    end
  end
end
