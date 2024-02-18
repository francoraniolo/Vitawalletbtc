class HomeController < ApplicationController
  include Turbo::Streams::Broadcasts

  def index
    @btc_rate = fetch_btc_rate
  end

  def fetch_btc_rate
    Coindesk::Service.fetch
  end
end
