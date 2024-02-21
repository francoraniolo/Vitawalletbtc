require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:sent_amount) }
    it { should validate_numericality_of(:sent_amount).is_greater_than(0) }
    it { should validate_presence_of(:sent_currency) }
    it { should validate_presence_of(:received_currency) }
    it { should validate_inclusion_of(:sent_currency).in_array(%w[usd btc]) }
    it { should validate_inclusion_of(:received_currency).in_array(%w[usd btc]) }
    it { should validate_presence_of(:operation_type) }
    it { should validate_inclusion_of(:operation_type).in_array(%w[buy sell]) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
