class CreateUnitConversionOrders < ActiveRecord::Migration
  def change
    create_table :unit_conversion_orders do |t|
      t.string :code
	    t.integer :unit_conversion_id
	    t.text :description
	    t.datetime :conversion_date
	    t.integer :warehouse_id
	    t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
