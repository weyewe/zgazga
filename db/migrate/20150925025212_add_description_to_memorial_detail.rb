class AddDescriptionToMemorialDetail < ActiveRecord::Migration
  def change
    add_column :memorial_details, :description, :string
  end
end
