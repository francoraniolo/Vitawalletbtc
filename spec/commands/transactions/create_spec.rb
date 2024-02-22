require 'rails_helper'

RSpec.describe Transactions::Create, type: :command do
  let(:user) { create(:user) }
  let(:sent_currency) { 'usd' }
  let(:received_currency) { 'btc' }
  let(:sent_amount) { 100 }

  subject(:command) { described_class.call(sent_currency: sent_currency,
                                           received_currency: received_currency,
                                           sent_amount: sent_amount,
                                           user: user ) }

  describe '.call' do
    context 'with valid input' do
      context 'for purchasing btc' do
        it "creates a transaction" do
          expect(command).to be_success
          expect(command.result).to be_an_instance_of(Transaction)
          expect(command.result.operation_type).to eq("buy")
          expect(user.usd_balance).to be < 1000000
          expect(user.btc_balance).to be > 0
          expect(user.transactions.count).to eq(1)
        end
      end

      context 'for selling btc' do
        let(:btc_balance) { 0.3454 }
        let(:user) { create(:user, btc_balance: btc_balance) }
        let(:sent_currency) { 'btc' }
        let(:received_currency) { 'usd' }
        let(:sent_amount) { 0.2 }

        it "creates a transaction" do
          expect(command).to be_success
          expect(command.result).to be_an_instance_of(Transaction)
          expect(command.result.operation_type).to eq("sell")
          expect(user.usd_balance).to be > 1000000
          expect(user.btc_balance).to be < btc_balance
          expect(user.transactions.count).to eq(1)
        end
      end
    end

    context 'with invalid input' do
      context 'with empty parameters' do
        context 'with empty sent currency' do
          let(:sent_currency) { nil }

          it "fails" do
            expect(command).to be_failure
            expect(command.errors[:sent_currency]).to include("Sent currency not found")
          end
        end
        context 'with empty received currency' do
          let(:received_currency) { nil }

          it "fails" do
            expect(command).to be_failure
            expect(command.errors[:received_currency]).to include("Received currency not found")
          end
        end
        context 'with empty sent amount' do
          let(:sent_amount) { nil }

          it "fails" do
            expect(command).to be_failure
            expect(command.errors[:sent_amount]).to include("Sent amount not found")
          end
        end
      end

      context 'with sent amount with a non positive value' do
        let(:sent_amount) { 0 }

        it "fails" do
          expect(command).to be_failure
          expect(command.errors[:base]).to include('Sent amount must be greater than zero')
        end
      end

      context 'with same received and sent currency' do
        let(:sent_currency) { 'usd' }
        let(:received_currency) { 'usd' }

        it "fails" do
          expect(command).to be_failure
          expect(command.errors[:base]).to include('Currencies must be different')
        end
      end

      context 'with insufficient founds' do
        let(:user) { create(:user, usd_balance: 0) }

        it "fails" do
          expect(command).to be_failure
          expect(command.errors[:base]).to include('Insufficient balance for the transaction')
        end
      end

      context 'with invalid currencies' do
        let(:sent_currency) { 'ars' }

        it "fails" do
          expect(command).to be_failure
          expect(command.errors[:base]).to include('Invalid currencies')
        end
      end
    end
  end
end
