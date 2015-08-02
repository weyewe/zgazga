class CreateMenuActionAssignments < ActiveRecord::Migration
  def change
    create_table :menu_action_assignments do |t|
      t.integer :menu_action_id
      t.integer :user_id 

      t.timestamps
    end
  end
end
