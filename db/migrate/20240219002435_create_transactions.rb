class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :sent_currency
      t.string :received_currency
      t.decimal :sent_amount, precision: 12, scale: 8
      t.string :type
      t.decimal :unit_price, precision: 12, scale: 8
      t.decimal :received_amount, precision: 12, scale: 8

      t.timestamps
    end
  end
end
