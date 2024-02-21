class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :usd_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :btc_balance, numericality: { greater_than_or_equal_to: 0 }

  has_many :transactions
end
