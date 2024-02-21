require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }
  let(:another_transaction) { create(:transaction, user: user) }

  before { sign_in user }

  describe 'GET /transactions' do
    before do
      get transactions_path
    end

    it 'returns a list of transactions' do

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
      expect(JSON.parse(response.body)).not_to be_empty
      binding.break
    end
  end
end
