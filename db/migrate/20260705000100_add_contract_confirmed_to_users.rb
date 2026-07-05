class AddContractConfirmedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :contract_confirmed, :boolean, default: false, null: false
  end
end
