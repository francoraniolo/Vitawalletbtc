module Coindesk
  #CURRENCY = "USD"
  CURRENCY = "usd"

  class Service
    #URI = 'https://api.coindesk.com/v1/bpi/currentprice.json'
    URI = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'

    def self.fetch
      response = Faraday.get(URI)
      raise Coindesk::ApiError unless response.success?
      Parser.new(response).to_common
    end
  end

  class Parser
    def initialize(response)
      @response = response
    end

    def to_common
      json_response = JSON.parse(@response.body)['bitcoin'][CURRENCY].to_f
    end
  end
end
