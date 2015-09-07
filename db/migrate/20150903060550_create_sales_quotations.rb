class CreateSalesQuotations < ActiveRecord::Migration
  def change
    create_table :sales_quotations do |t|
      t.string :code
      t.string :version_no
      t.string :nomor_surat
      t.integer :contact_id
      t.text  :description
      t.datetime :quotation_date
      t.decimal :total_quote_amount ,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :total_rrp_amount ,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :cost_saved ,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :percentage_saved,  :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :is_approved , :default => false
      t.boolean :is_rejected , :default => false
      t.boolean :is_sales_order_confirmed , :default => false
      t.timestamps
    end
  end
end
