class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
    render json: @transactions, each_serializer: TransactionSerializer, root: :transactions
  end

  def create
    command =  Transactions::Create.call(sent_currency: sent_currency,
      received_currency: received_currency,
      sent_amount: sent_amount,
      user: current_user)

    if command.success?
      render json: command.result, serializer: TransactionSerializer
    else
      render json: { error: command.errors.first.message }, status: :unprocessable_entity
    end
  end

  def show
    @transaction = current_user.transactions.find(params[:id])
    render json: @transaction, serializer: TransactionSerializer
  end

  private

  def sent_amount
    @sent_amount = params[:sent_amount]
  end

  def sent_currency
    @sent_currency = params[:sent_currency]
  end

  def received_currency
    @received_currency = params[:received_currency]
  end
end
