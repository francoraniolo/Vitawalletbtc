class Transaction < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :sent_currency, presence: true
  validates :received_currency, presence: true
  validates :sent_amount, presence: true, numericality: { greater_than: 0 }
  validates :type, presence: true, inclusion: { in: %w(buy sell) }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validate :sufficient_balance_for_purchase, if: -> { type == 'buy' }

  before_save :calculate_received_amount

  private

  def sufficient_balance_for_purchase
    unless user.sufficient_balance?(sent_currency, sent_amount)
      errors.add(:base, 'Insufficient balance to complete the purchase')
    end
  end

  def calculate_received_amount
    self.received_amount = sent_amount / unit_price
  end
end
