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
    @transaction = current_user.transactions.find_by(id: params[:id])

    if @transaction
      render json: @transaction, serializer: TransactionSerializer
    else
      render json: { error: 'Transaction not found' }, status: :not_found
    end
  end

  private

  def transaction_params
    params.permit(:sent_currency, :received_currency, :sent_amount)
  end

  def sent_amount
    @sent_amount = transaction_params[:sent_amount]
  end

  def sent_currency
    @sent_currency = transaction_params[:sent_currency]
  end

  def received_currency
    @received_currency = transaction_params[:received_currency]
  end
end
