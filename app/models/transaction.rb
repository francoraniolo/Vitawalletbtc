class Transaction < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :sent_amount, presence: true, numericality: { greater_than: 0 }
  validates :sent_currency, :received_currency, presence: true, inclusion: { in: %w(usd btc) }
  validates :operation_type, presence: true, inclusion: { in: %w(buy sell) }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
