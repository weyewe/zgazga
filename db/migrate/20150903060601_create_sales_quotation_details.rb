class CreateSalesQuotationDetails < ActiveRecord::Migration
  def change
    create_table :sales_quotation_details do |t|
      t.string :code
      t.integer :sales_quotation_id
      t.integer :item_id
      t.decimal :amount ,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :rrp ,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :quotation_price ,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
