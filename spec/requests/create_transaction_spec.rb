require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:sent_currency) { 'usd' }
  let(:received_currency) { 'btc' }
  let(:sent_amount) { 100.0 }

  before { sign_in user }

  describe 'POST /transactions' do

    before do
      post :create, params: {sent_currency: sent_currency, received_currency: received_currency, sent_amount: sent_amount}, as: :json
    end

    context 'with valid parameters' do
      it 'creates a new transaction' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(user.transactions.size).to eq(1)
        expect(JSON.parse(response.body)["user"]).to eq(user.email)
        expect(JSON.parse(response.body)["sent_amount"].to_f).to eq(sent_amount)
        expect(JSON.parse(response.body)["operation_type"]).to eq('buy')
      end
    end

    context 'with invalid parameters' do
      context 'with non positive sent amount' do
        let(:sent_amount) { 0 }

        it 'returns an error message' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)["error"]).to eq('Sent amount must be greater than zero')
        end
      end

      context 'with Insufficient balance' do
        let(:sent_amount) { user.usd_balance + 1 }

        it 'returns an error message' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)["error"]).to eq('Insufficient balance for the transaction')
        end
      end

      context 'with same currencies' do
        let(:sent_currency) {'usd'}
        let(:received_currency) {'usd'}

        it 'returns an error message' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)["error"]).to eq('Currencies must be different')
        end
      end

      context 'with invalid currencies' do
        let(:sent_currency) {'ars'}

        it 'returns an error message' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)["error"]).to eq('Invalid currencies')
        end
      end

      context 'with null parameter' do
        let(:sent_currency) { nil }

        it 'returns an error message' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)["error"]).to eq('Sent currency not found')
        end
      end
    end
  end
end
