require_relative "../config/application"
require 'logger'

LOGGER = Logger.new(STDOUT)

ImporterClass = Importer::Orders

# class ImporterWithCustomErrorsHandling < Importer::Orders
#   protected

#   def handle_order_create_errors(&block)
#     yield
#   rescue Importer::HubriseClientError => ex
#     LOGGER.info("+++#{ex.message}+++")
#   end
# end
# ImporterClass = ImporterWithCustomErrorsHandling

shopify_client = Importer::Client::Shopify.new(ENV["SHOPIFY_SHOP_URL"], ENV["SHOPIFY_API_VERSION"])
hubrise_client = Importer::Client::Hubrise.new(ENV["HUBRISE_ACCESS_TOKEN"])
importer = ImporterClass.new(
  source_client: shopify_client,
  destination_client: hubrise_client,
  decorator_class: Importer::OrderDecorator,
  force_curency: "EUR"
)

begin
  importer.import!
rescue Importer::Error => ex
  LOGGER.warn(ex.message)
end
