class CreateMenuActions < ActiveRecord::Migration
  def change
    create_table :menu_actions do |t|
      t.integer :menu_id 
      t.string :action_name
      t.string :name 
      
      t.timestamps
    end
  end
end
