class CreateUnitConversionDetails < ActiveRecord::Migration
  def change
    create_table :unit_conversion_details do |t|
      t.integer :unit_conversion_id
      t.integer :item_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
