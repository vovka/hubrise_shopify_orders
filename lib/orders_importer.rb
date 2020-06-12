require_relative "order_decorator"
require_relative "client"

class OrdersImporter
  attr_reader :shopify_client, :hubrise_client
  private :shopify_client, :hubrise_client

  def initialize(shopify_client: Client::Shopify.new(), hubrise_client: Client::Hubrise.new())
    @shopify_client = shopify_client
    @hubrise_client = hubrise_client
  end

  def import!
    orders = shopify_client.orders
    orders.each do |order|
      decorated_order = OrderDecorator.new(order)
      hubrise_client.create_order!(decorated_order.to_h)
    end
  end
end
