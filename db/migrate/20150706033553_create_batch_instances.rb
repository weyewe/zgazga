class CreateBatchInstances < ActiveRecord::Migration
  def change
    create_table :batch_instances do |t|
      
      t.integer :item_id 
      t.string :name
      t.text :description 
      
      t.datetime :manufactured_at 
      t.datetime :expiry_date 
      
      t.decimal :amount, :default => 0  ,:precision => 14, :scale => 2      

      t.timestamps
    end
  end
end
