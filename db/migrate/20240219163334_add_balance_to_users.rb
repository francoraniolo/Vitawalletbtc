class AddBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :usd_balance, :decimal, precision: 10, scale: 2, default: 1000000.0
    add_column :users, :btc_balance, :decimal, precision: 16, scale: 8, default: 0.0
  end
end
