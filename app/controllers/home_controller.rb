class HomeController < ApplicationController
  include Turbo::Streams::Broadcasts

  def index
    @btc_rate = fetch_btc_rate
    respond_to do |format|
      format.html { render }
      format.turbo_stream  { render turbo_stream: turbo_stream.replace('btc-rate', partial: 'btc_rate', locals: { btc_rate: @btc_rate }) }
    end
  end

  def fetch_btc_rate
    Coindesk::Service.fetch
  end
end
