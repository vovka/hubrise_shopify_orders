# require "net/http"
# require "uri"
# require "json"

module Importer
  module Client
    class Hubrise
      ORDERS_URI = "https://api.hubrise.com/v1/location/orders".freeze
      HEADER = {"Content-Type": "application/json"}.freeze
      HTTP_SUCCESS_CODE_RANGE = (200..299).freeze

      attr_reader :http, :header, :create_orders_uri
      private :http, :header, :create_orders_uri

      def initialize(access_token = ENV["HUBRISE_ACCESS_TOKEN"])
        @header = HEADER.merge("X-Access-Token": access_token)
        @create_orders_uri = URI(ORDERS_URI)
        @http = Net::HTTP.new(create_orders_uri.host, create_orders_uri.port)
        http.use_ssl = true
      end

      def create_order!(order_hash)
        request = Net::HTTP::Post.new(create_orders_uri, header)
        request.body = order_hash.to_json
        response = http.request(request)
        handle_errors(response) unless response.code.to_i.in?(HTTP_SUCCESS_CODE_RANGE)
        [request, response]
      end

      protected

      def handle_errors(response)
        error_hash = JSON.parse(response.body)
        case response.code.to_i
        when 401 #unauthorized
          msg = error_hash["error_type"]
          raise HubriseUnauthorizedError.new(msg)
        when 422 #unprocessible
          msg = "#{error_hash["error_type"]}. #{error_hash["message"]}. "
          msg += error_hash["errors"].map { |err| "#{err["field"]} #{err["message"]}" }.join(". ")
          raise HubriseUnprocessibleEntityError.new(msg)
        end
      end
    end
  end
end
