class PricesController < ApplicationController
  def btc
   data = Coindesk::Service.fetch
   render json: data
  end
end
