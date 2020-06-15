describe Importer::Client::Hubrise do
  before do
  end

  describe "#create_order!" do
    it "performs POST to create an order" do
      stub_request(:post, "https://api.hubrise.com/v1/location/orders")
        .with(body: { status: "new" }.to_json).to_return(status: 200)

      subject.create_order!({ status: "new" })

      expect(WebMock).to have_requested(:post, "https://api.hubrise.com/v1/location/orders")
        .with(body: { status: "new" }.to_json)
    end

    it "raises exception when 401" do
      stub_request(:post, "https://api.hubrise.com/v1/location/orders")
        .with(body: { status: "new" }.to_json).to_return(status: 401, body: { error_type: ""}.to_json )

      expect { subject.create_order!({ status: "new" }) }.to raise_error(Importer::HubriseUnauthorizedError)
    end

    it "raises exception when 422" do
      stub_request(:post, "https://api.hubrise.com/v1/location/orders")
        .with(body: { status: "new" }.to_json).to_return(status: 422, body: { error_type: "", message: "", errors: [{field: "", message: ""}]}.to_json )

      expect { subject.create_order!({ status: "new" }) }.to raise_error(Importer::HubriseUnprocessibleEntityError)
    end
  end
end
