require_relative "../config/application"

importer = Importer::Orders.new
importer.import!
