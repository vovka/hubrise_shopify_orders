describe Importer::Orders do
  class SourceClientClassMock
    def orders
      [ { order: "success" }, { order: "success again" } ]
    end
  end

  class DestinationClientClassMock
    attr_reader :has_created

    def initialize
      @has_created = []
    end

    def create_order!(order)
      @has_created << order
    end
  end

  class DecoratorClassMock < OpenStruct
    def initialize(order, _force_currency = nil)
      super(order)
    end
  end

  let(:source) { SourceClientClassMock.new }
  let(:destination) { DestinationClientClassMock.new }
  let(:decorator_class) { DecoratorClassMock }
  let(:force_currency) {}

  subject { described_class.new(source_client: source, destination_client: destination, decorator_class: decorator_class, force_currency: force_currency) }

  describe "#import!" do
    it "creates orders" do
      subject.import!

      expect(destination.has_created).to eq([ { order: "success" }, { order: "success again" } ])
    end

    it "handles exceptions and proceeds by default" do
      allow(destination).to receive(:create_order!).and_call_original
      allow(destination).to receive(:create_order!).with({ order: "success" }).and_raise(Importer::HubriseUnprocessibleEntityError)

      subject.import!

      expect(destination.has_created).to eq([ { order: "success again" } ])
    end

    it "aborts when there are no exceptions handling" do
      def subject.handle_order_create_errors(&block)
        yield
      end
      allow(destination).to receive(:create_order!).and_call_original
      allow(destination).to receive(:create_order!).with({ order: "success" }).and_raise(Importer::HubriseUnprocessibleEntityError)

      expect { subject.import! }.to raise_error(Importer::HubriseUnprocessibleEntityError)
      expect(destination.has_created).to eq([])
    end
  end
end
