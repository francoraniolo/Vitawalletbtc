require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:sent_amount) }
    it { is_expected.to validate_numericality_of(:sent_amount).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:sent_currency) }
    it { is_expected.to validate_presence_of(:received_currency) }
    it { is_expected.to validate_inclusion_of(:sent_currency).in_array(%w[usd btc]) }
    it { is_expected.to validate_inclusion_of(:received_currency).in_array(%w[usd btc]) }
    it { is_expected.to validate_presence_of(:operation_type) }
    it { is_expected.to validate_inclusion_of(:operation_type).in_array(%w[buy sell]) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_numericality_of(:unit_price).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
