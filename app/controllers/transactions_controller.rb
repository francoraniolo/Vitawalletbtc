class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions
    render json: @transactions, status: :ok
  end

  def buy
  end

  def sell
  end
end
