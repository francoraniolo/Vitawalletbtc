module Transaction
  class Create
    prepend SimpleCommand
    include ActiveModel::Validations

    validates :sent_currency, :received_currency, presence: true, inclusion: { in: %w(usd btc) }
    validates :sent_amount, presence: true
    validate :sent_amount_greater_than_zero
    validate :sufficient_balance

    attr_accessor :received_currency, :sent_currency, :sent_amount, :unit_price
    attr_reader :transaction

    def call
      return errors unless valid?

      ActiveRecord::Base.transaction do
        create_transaction
        update_balances
        transaction
      end
    end

    private

    def base_balance
      @base_balance ||= sent_currency == :usd ? user.usd_balance : user.btc_balance
    end

    def btc_rate
      @btc_rate ||= Coindesk::Service.fetch
    end

    def create_transaction
      @transaction = user.transactions.create!(sent_currency:,
                                               received_currency:,
                                               type: type,
                                               sent_amount:,
                                               received_amount: received_amount,
                                               unit_price: unit_price
                                               )
    end

    def received_amount
      @received_amount ||= sent_amount / unit_price
    end

    def sent_amount_greater_than_zero
      errors.add(:sent_amount, 'must be greater than zero') unless sent_amount.to_f > 0
    end

    def sufficient_balance
      errors.add(:base, 'Insufficient balance for the transaction') if sent_amount.to_f > base_balance
    end

    def type
      @type ||= received_currency == :btc ? :buy : :sell
    end

    def unit_price
      @unit_price ||= sent_currency == :usd ? btc_rate : 1 / btc_rate
    end

    def update_balances
      if type == :buy
        user.update!(usd_balance: user.usd_balance - sent_amount,
                     btc_balance: user.btc_balance + received_amount)
      else
        user.update!(usd_balance: user.usd_balance + received_amount,
                     btc_balance: user.btc_balance - sent_amount)
      end
    end

    def user
      @user ||= current_user
    end
  end
end
