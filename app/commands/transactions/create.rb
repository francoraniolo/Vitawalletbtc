module Transactions
  class Create
    prepend SimpleCommand
    include ActiveModel::Validations

    validates_presence_of :sent_amount, message: "Sent amount not found"
    validates_presence_of :sent_currency, message: "Sent currency not found"
    validates_presence_of :received_currency, message: "Received currency not found"

    validate :different_currency?, :sent_amount_greater_than_zero?, :valid_currencies?, :sufficient_balance?

    attr_accessor :received_currency, :sent_currency, :sent_amount, :unit_price
    attr_reader :transaction, :user

    def initialize(sent_currency:, sent_amount:, received_currency:, user:)
      @sent_currency = sent_currency
      @sent_amount = sent_amount
      @received_currency = received_currency
      @user = user
    end

    def call
      return errors unless valid?

      ActiveRecord::Base.transaction do
        create_transaction
        update_balances
        transaction
      end

      rescue ActiveRecord::RecordInvalid => e
        errors.add(:base, e.message)
    end

    private

    def base_balance
      @base_balance ||= sent_currency == "usd" ? user.usd_balance : user.btc_balance
    end

    def btc_rate
      @btc_rate ||= Coindesk::Service.fetch
    end

    def create_transaction
      @transaction = user.transactions.create!(
        sent_currency: sent_currency,
        received_currency: received_currency,
        operation_type: operation_type,
        sent_amount: sent_amount,
        received_amount: received_amount,
        unit_price: unit_price
                                               )
    end

    def different_currency?
      errors.add(:base, 'Currencies must be different') if sent_currency == received_currency
    end

    def received_amount
      @received_amount ||= sent_amount / unit_price
    end

    def sent_amount_greater_than_zero?
      errors.add(:base, 'Sent amount must be greater than zero') unless sent_amount.to_f > 0
    end

    def sufficient_balance?
      errors.add(:base, 'Insufficient balance for the transaction') if sent_amount.to_f > base_balance
    end

    def operation_type
      @operation_type ||= received_currency == "btc" ? "buy" : "sell"
    end

    def unit_price
      @unit_price ||= sent_currency == "usd" ? btc_rate : 1 / btc_rate
    end

    def update_balances
      if operation_type == "buy"
        user.update!(usd_balance: user.usd_balance - sent_amount,
                     btc_balance: user.btc_balance + received_amount)
      else
        user.update!(usd_balance: user.usd_balance + received_amount,
                     btc_balance: user.btc_balance - sent_amount)
      end
    end

    def valid_currencies?
      errors.add(:base, 'Invalid currencies') unless %w(btc usd).include?(sent_currency) &&  %w(btc usd).include?(received_currency)
    end
  end
end
