class PricesController < ApplicationController
  def btc
   data = Coindesk::Service.fetch
   render json: data, status: :ok
  end
end
