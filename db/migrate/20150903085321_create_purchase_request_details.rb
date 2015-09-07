class CreatePurchaseRequestDetails < ActiveRecord::Migration
  def change
    create_table :purchase_request_details do |t|
      t.integer :purchase_request_id
      t.string  :name
      t.string :code
      t.string  :uom
      t.text  :description
      t.integer :category
      t.decimal :amount ,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
