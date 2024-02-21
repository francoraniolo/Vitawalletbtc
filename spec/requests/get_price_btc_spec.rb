require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  let!(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /prices/btc' do
    it 'returns the BTC rate' do
      allow(Coindesk::Service).to receive(:fetch).and_return({ 'btc_rate' => 50000.0 })

      get :btc

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.body).to eq({ btc_rate: 50000.0 }.to_json)
    end
  end
end
