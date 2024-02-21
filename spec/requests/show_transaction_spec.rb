require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:transaction) { create(:transaction, user: user) }
  let!(:another_user) { create(:user) }
  let!(:another_transaction) { create(:transaction, user: another_user) }

  before { sign_in user }

  describe 'GET /transactions/:id' do
    context 'when transaction belongs to user' do
      before do
        get :show, params: { id: transaction.id }
      end

      it 'returns a single transaction' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)["user"]).to eq(user.email)
      end
    end

    context 'when transaction does not belong to user' do
      before do
        get :show, params: { id: another_transaction.id }
      end

      it 'returns error 404' do
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
