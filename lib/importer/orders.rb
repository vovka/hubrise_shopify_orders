require_relative "order_decorator"
require_relative "client"

module Importer
  class Orders
    attr_reader :source_client, :destination_client, :decorator_class, :currency
    private :source_client, :destination_client, :decorator_class, :currency

    def initialize(source_client: Importer::Client::Shopify.new, destination_client: Importer::Client::Hubrise.new, decorator_class: OrderDecorator, force_currency: nil)
      @source_client = source_client
      @destination_client = destination_client
      @decorator_class = decorator_class
      @currency = force_currency
    end

    def import!
      orders = source_client.orders
      orders.each do |order|
        handle_order_create_errors do
          decorated_order = decorator_class.new(order, currency)
          _request, _response = destination_client.create_order!(decorated_order.to_h)
        end
      end
    end

    protected

    def handle_order_create_errors(&block)
      yield
    rescue HubriseUnprocessibleEntityError => ex
      pp ex.message
    end
  end
end
