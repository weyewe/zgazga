class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name
      t.text :description
      t.boolean :is_base, :default => false 
      t.timestamps
    end
  end
end
