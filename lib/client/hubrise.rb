require 'net/http'
require 'uri'
require 'json'

module Client
  class Hubrise
    ORDERS_URI = "https://api.hubrise.com/v1/location/orders".freeze
    HEADER = {'Content-Type': 'application/json'}.freeze

    attr_reader :access_token
    private :access_token

    def initialize(access_token: ENV["HUBRISE_ACCESS_TOKEN"])
      @access_token = access_token
    end

    def create_order!(order_hash)
      uri = URI(ORDERS_URI)

      header = HEADER.merge("X-Access-Token": access_token)
      # order = { status: "new" }

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri, header)
      request.body = order_hash.to_json
      pp request.body

      # Send the request
      response = http.request(request)
      pp response.body
      JSON.parse(response.body)
    end
  end
end
