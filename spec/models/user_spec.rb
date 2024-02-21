require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:usd_balance) }
    it { should validate_numericality_of(:usd_balance).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:btc_balance).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should have_many(:transactions) }
  end

  describe 'defaults' do
    let(:user) { create(:user) }

    it 'sets default values' do
      expect(user.usd_balance).to eq(1000000.0)
      expect(user.btc_balance).to eq(0)
    end
  end
end
