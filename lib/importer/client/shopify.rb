module Importer
  module Client
    class Shopify
      def initialize(shop_url = ENV["SHOPIFY_SHOP_URL"], api_version = ENV["SHOPIFY_API_VERSION"])
        ShopifyAPI::Base.site = shop_url
        ShopifyAPI::Base.api_version = api_version
      end

      def orders
        result = ShopifyAPI::Order.all
        raise ShopifyBlankResponseError.new if result.nil?
        result
      rescue ActiveResource::ForbiddenAccess, ActiveResource::UnauthorizedAccess => ex
        raise ShopifyAccessError.new(ex.message)
      end
    end
  end
end
