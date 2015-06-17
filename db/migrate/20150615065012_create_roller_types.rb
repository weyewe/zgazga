class CreateRollerTypes < ActiveRecord::Migration
  def change
    create_table :roller_types do |t|

      t.timestamps
    end
  end
end
