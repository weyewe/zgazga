class CreateRollerBuilders < ActiveRecord::Migration
  def change
    create_table :roller_builders do |t|
      
      t.timestamps
    end
  end
end
