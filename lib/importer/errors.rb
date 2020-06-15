module Importer
  class Error < StandardError
    def initialize(message = "")
      super("Orders importer error. #{message}")
    end
  end

  class ClientError < Error; end

  class ShopifyClientError < ClientError
    def initialize(message = "")
      super("Shopify client #{message}")
    end
  end

  class ShopifyBlankResponseError < ShopifyClientError
    def initialize(message = "")
      super("returned nothing. It may be caused by wrong shop URL or API version. Please, check if it is valid. #{message}")
    end
  end

  class ShopifyAccessError < ShopifyClientError; end

  class HubriseClientError < ClientError
    def initialize(message = "")
      super("Hubrise client #{message}. ")
    end
  end

  class HubriseUnauthorizedError < HubriseClientError; end
  class HubriseUnprocessibleEntityError < HubriseClientError; end
end
