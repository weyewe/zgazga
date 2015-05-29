class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.text :description
      t.boolean :is_legacy , :default => false
      t.integer :chart_of_account_id
      t.timestamps
    end
  end
end
