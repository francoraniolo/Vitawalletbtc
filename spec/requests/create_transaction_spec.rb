require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  let(:user) { create(:user) }
  let(:sent_currency) { 'usd' }
  let(:received_currency) { 'btc' }
  let(:sent_amount) { 100 }

  before { sign_in user }

  describe 'POST /transactions' do
    before do
      post transactions_path(sent_currency: sent_currency, received_currency: received_currency, sent_amount: sent_amount)
    end

    context 'with valid parameters' do
      it 'creates a new transaction' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(Transaction.count).to eq(1)
        binding.break
      end
    end

    context 'with invalid parameters' do
      let(:sent_amount) { 0 }

      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)).to have_key('error')
        binding.break
      end
    end
  end
end
