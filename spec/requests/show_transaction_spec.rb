require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }
  let(:another_transaction) { create(:transaction) }

  before { sign_in user }

  describe 'GET /transactions/:id' do
    context 'when transaction belongs to user' do
      before do
        get transactions_path(id: transaction.id)
      end

      it 'returns a single transaction' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)).not_to be_empty
        binding.break
      end
    end

    context 'when transaction does not belong to user' do
      before do
        get transactions_path(id: another_transaction.id)
      end

      it 'returns error 404' do
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json')
        expect(JSON.parse(response.body)).not_to be_empty
        binding.break
      end
    end
  end
end
