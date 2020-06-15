describe "Shopify to Hubrise import general flow" do
  it "pulls orders from shopify and pushes to hubrise" do
    shopify_client = Importer::Client::Shopify.new("https://test-store.myshopify.com", "2020-01-test-api-version")
    hubrise_client = Importer::Client::Hubrise.new("some-test-token")
    importer = Importer::Orders.new(source_client: shopify_client, destination_client: hubrise_client, force_currency: "EUR")

    shopify_body_json = File.read("spec/fixtures/http/shopify_get_orders_body.json")
    stub_request(:get, "https://test-store.myshopify.com/admin/api/2020-01-test-api-version/orders.json")
      .to_return(status: 200, body: shopify_body_json)
    stub_request(:post, "https://api.hubrise.com/v1/location/orders").to_return(status: 200)

    importer.import!

    expect(WebMock).to have_requested(:get, "https://test-store.myshopify.com/admin/api/2020-01-test-api-version/orders.json")
    expect(WebMock).to have_requested(:post, "https://api.hubrise.com/v1/location/orders")
      .with(body: {
        private_ref: "45de20b8b3b6d7074b3ba7fd7408b801",
        status: "received",
        seller_notes: "Another order",
        total: "294.48 EUR",
        items: [{
          product_name: "iPhone SE",
          sku_name: "",
          price: "321.00 EUR",
          quantity: 1
        }],
        discounts: [{
          name: "For a good person:)",
          price_off: "38.52 EUR"
        }]
      }.to_json)
  end
end
