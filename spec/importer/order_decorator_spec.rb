describe Importer::OrderDecorator do
  let(:order_hash) do
    {
      token: "some token",
      customer: {
        notes: "some notes"
      },
      note: "some seller notes",
      discount_applications: [
        {
          type: "discount_code",
          value: "COUPON1"
        },
        {
          type: "discount_code",
          value: "COUPON2"
        }
      ],
      total_price: "123",
      currency: "USD",
      line_items: [
        {
          name: "Some product name",
          sku: "SKU",
          price: "123",
          quantity: 1
        },
        {
          name: "Another product name",
          sku: "SKU2",
          price: "321",
          quantity: 2
        }
      ],
      discount_codes: [
        {
          code: "Some discount code",
          amount: "12"
        },
        {
          code: "Another discount code",
          amount: "21"
        }
      ]
    }
  end
  let(:order) { JSON.parse(order_hash.to_json, object_class: OpenStruct) }
  subject {  described_class.new(order, @currency) }

  describe "#private_ref" do
    specify { expect(subject.private_ref).to eq("some token") }
  end

  describe "#status" do
    it "uses fulfillment status first" do
      order.fulfillment_status = "voided"
      order.financial_status = "fulfilled"

      expect(subject.status).to eq("rejected")
    end

    it "uses financial status" do
      order.financial_status = "fulfilled"

      expect(subject.status).to eq("completed")
    end
  end

  describe "#service_type" do
  end

  describe "#service_type_ref" do
  end

  describe "#expected_time" do
  end

  describe "#confirmed_time" do
  end

  describe "#customer_notes" do
    it "uses customer.notes property" do
      expect(subject.customer_notes).to eq("some notes")
    end

    it "returns nil when no customer.notes provided" do
      order.customer = {}

      expect(subject.customer_notes).to be_nil
    end
  end

  describe "#seller_notes" do
    specify { expect(subject.seller_notes).to eq("some seller notes") }
  end

  describe "#coupon_codes" do
    it "returns coupon values" do
      expect(subject.coupon_codes).to eq("COUPON1,COUPON2")
    end
  end

  describe "#collection_code" do
  end

  describe "#total" do
    it "uses total_price and currency properties" do
      expect(subject.total).to eq("123 USD")
    end

    it "adds custom currency" do
      @currency = "EUR"

      expect(subject.total).to eq("123 EUR")
    end
  end

  describe "#custom_fields" do
  end

  describe "#items" do
    specify do
      expect(subject.items).to eq([
        {
          product_name: "Some product name",
          sku_name: "SKU",
          price: "123 USD",
          quantity: 1
        },
        {
          product_name: "Another product name",
          sku_name: "SKU2",
          price: "321 USD",
          quantity: 2
        }
      ])
    end
  end

  describe "#loyalty_operations" do
  end

  describe "#charges" do
  end

  describe "#payments" do
  end

  describe "#discounts" do
    specify do
      expect(subject.discounts).to eq([
        {
          name: "Some discount code",
          price_off: "12 USD"
        },
        {
          name: "Another discount code",
          price_off: "21 USD"
        }
      ])
    end
  end

  describe "#deals" do
  end

  describe "#customer" do
  end

  describe "#customer_list_id" do
  end

  describe "#customer_private_ref" do
  end
end
