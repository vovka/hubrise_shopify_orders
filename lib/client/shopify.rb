require 'shopify_api'

module Client
  class Shopify
    def initialize(shopify_shop_url: ENV["SHOPIFY_SHOP_URL"], shopify_api_version: ENV["SHOPIFY_API_VERSION"])
      ShopifyAPI::Base.site = shopify_shop_url
      ShopifyAPI::Base.api_version = shopify_api_version
    end

    def orders
      # products = ShopifyAPI::Product.find(:all)
      # pp products

      # draft_orders = ShopifyAPI::DraftOrder.all
      orders = ShopifyAPI::Order.all
      # orders = orders.map(&:attributes)
      pp orders
      orders
    end
  end
end
