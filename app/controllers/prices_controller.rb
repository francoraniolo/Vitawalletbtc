class PricesController < ApplicationController
  def btc
    btc_rate = Coindesk::Service.fetch
    render json: btc_rate, status: :ok
  end
end
