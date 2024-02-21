require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:transaction) { create(:transaction, user: user) }
  let!(:another_transaction) { create(:transaction, user: user) }

  before { sign_in user }

  describe 'GET /transactions' do
    before do
      get :index
    end

    it 'returns a list of transactions' do
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body).size).to eq 2
      expect(JSON.parse(response.body).first["user"]).to eq(user.email)
      expect(JSON.parse(response.body).second["user"]).to eq(user.email)
    end
  end
end
