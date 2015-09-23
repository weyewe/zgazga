class AddCutArToBlanket < ActiveRecord::Migration
  def change
     add_column :blankets,  :cut_ar , :decimal, :default        => 0,  :precision => 14, :scale => 2
  end
end
