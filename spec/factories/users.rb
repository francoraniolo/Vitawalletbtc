FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '123456' }
    btc_balance { 0.0 }
    usd_balance { 1000000 }
  end
end
