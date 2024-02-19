class AddBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :usd_balance, :decimal, precision: 12, scale: 8, default: 1000000.0
    add_column :users, :btc_balance, :decimal, precision: 12, scale: 8, default: 0.0
  end
end
