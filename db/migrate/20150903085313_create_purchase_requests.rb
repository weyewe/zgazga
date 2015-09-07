class CreatePurchaseRequests < ActiveRecord::Migration
  def change
    create_table :purchase_requests do |t|
      t.string :code
      t.string :nomor_surat
      t.integer :employee_id
      t.datetime :request_date
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      
      t.timestamps
    end
  end
end
