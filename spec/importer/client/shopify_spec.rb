describe Importer::Client::Shopify do
  describe "#orders" do
    it "returns orders" do
      allow(ShopifyAPI::Order).to receive(:all).and_return([:order1, :order2])

      expect(subject.orders).to eq([:order1, :order2])
    end

    it "raises exception when there are no orders" do
      allow(ShopifyAPI::Order).to receive(:all).and_return(nil)

      expect { subject.orders }.to raise_error(Importer::ShopifyBlankResponseError)
    end

    it "raises exception when access is forbidden" do
      allow(ShopifyAPI::Order).to receive(:all).and_raise(ActiveResource::ForbiddenAccess.new(nil))

      expect { subject.orders }.to raise_error(Importer::ShopifyAccessError)
    end

    it "raises exception when unauthorized" do
      allow(ShopifyAPI::Order).to receive(:all).and_raise(ActiveResource::UnauthorizedAccess.new(nil))

      expect { subject.orders }.to raise_error(Importer::ShopifyAccessError)
    end
  end
end
