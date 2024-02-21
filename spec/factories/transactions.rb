FactoryBot.define do
  factory :transaction do
    association :user
    sent_currency { 'usd' }
    received_currency { 'btc' }
    sent_amount { Faker::Number.decimal(l_digits: 8, r_digits: 8).to_f }
    operation_type { 'buy' }
    unit_price { Faker::Number.decimal(l_digits: 8, r_digits: 8).to_f }
    received_amount { sent_amount / unit_price }
  end
end
