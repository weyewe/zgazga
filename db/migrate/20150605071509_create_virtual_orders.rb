class CreateVirtualOrders < ActiveRecord::Migration
  def change
    create_table :virtual_orders do |t|
      t.string :code
      t.integer :contact_id
      t.integer :order_type
      t.datetime :order_date
      t.string  :nomor_surat
      t.integer :exchange_id
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :is_delivery_completed, :default => false
      t.timestamps
    end
  end
end
