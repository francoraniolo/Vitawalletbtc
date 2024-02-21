module Coindesk
  CURRENCY = "USD"

  class Service
    URI = 'https://api.coindesk.com/v1/bpi/currentprice.json'

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
      json_response = JSON.parse(@response.body)["bpi"][CURRENCY]["rate_float"].round(2)
    end
  end
end
