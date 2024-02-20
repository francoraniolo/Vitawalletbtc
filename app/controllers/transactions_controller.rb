class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
    render json: @transactions, each_serializer: TransactionSerializer, root: :transactions
  end

  def create
    command =  Transactions::Create.call(transaction_params.merge(user: current_user))
    binding.break

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

  def transaction_params
    params.permit(:sent_currency, :received_currency, :sent_amount)
  end
end
