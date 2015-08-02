class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name 
      t.string :controller_name 
      
      
      t.timestamps
    end
  end
end
