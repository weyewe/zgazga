class CreateChartOfAccounts < ActiveRecord::Migration
  def change
    create_table :chart_of_accounts do |t|
      t.string :code
      t.string :name
      t.integer :group
      t.integer :level
      t.integer :parent_id
      t.boolean :is_legacy , :default => false
      t.boolean :is_leaf , :default => false
      t.boolean :is_cash_bank_account , :default => false
      t.string :legacy_code
      t.boolean :is_payable_receivable ,:default => false
      t.timestamps
    end
  end
end
