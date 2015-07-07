class AddBatchInstanceToRecoveryOrderDetail < ActiveRecord::Migration
  def change
    add_column :recovery_order_details, :compound_batch_instance_id, :integer 
  end
end
