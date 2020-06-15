module Importer
  class OrderDecorator
    attr_reader :order, :currency
    private :order, :currency

    FIELDS_LIST = %i[
      private_ref
      status
      service_type
      service_type_ref
      expected_time
      confirmed_time
      customer_notes
      seller_notes
      coupon_codes
      collection_code
      total
      custom_fields
      items
      loyalty_operations
      charges
      payments
      discounts
      deals
      customer
      customer_list_id
      customer_private_ref
    ].freeze
    STATUSES_MAP = {
      "pending" => "new",
      "authorized" => "new",
      "partially_paid" => "new",
      "paid" => "received",
      "partially_refunded" => "accepted",
      "refunded" => "cancelled",
      "voided" => "rejected",

      "fulfilled" => "completed",
      # "null" => "",
      # "partial" => "",
      "restocked" => "cancelled"
    }.freeze
    COUPON = "discount_code".freeze

    def initialize(order, currency_iso_4217 = nil)
      @order = order
      @currency = currency_iso_4217
    end

    def to_h
      result = {}
      FIELDS_LIST.each do |field|
        value = send(field) if respond_to?(field, true)
        result.merge!(field => value) if value.present?
      end
      result
    end

    def private_ref
      order.token
    end

    def status
      STATUSES_MAP[order.fulfillment_status] || STATUSES_MAP[order.financial_status]
    end

    def service_type
      #TODO:
    end

    def service_type_ref
      #TODO:
    end

    def expected_time
      #TODO:
    end

    def confirmed_time
      #TODO:
    end

    def customer_notes
      order.customer["notes"] if order.respond_to?(:customer)
    end

    def seller_notes
      order.note
    end

    def coupon_codes
      order.discount_applications.select { |hsh| hsh.type == COUPON }.map { |hsh| hsh.value }.join(",")
    end

    def collection_code
      #TODO:
    end

    def total
      "#{order.total_price} #{currency || order.currency}"
    end

    def custom_fields
      #TODO:
    end

    def items
      order.line_items.map do |line_item|
        {
          product_name: line_item.name,
          sku_name: line_item.sku,
          # sku_ref: line_item.,
          price: "#{line_item.price} #{currency || order.currency}",
          quantity: line_item.quantity,
          # options: line_item.,
          # points_earned: line_item.,
          # points_used: line_item.
        }
      end
    end

    def loyalty_operations
      #TODO:
    end

    def charges
      #TODO:
    end

    def payments
      #TODO:
      # order.processing_method
    end

    def discounts
      order.discount_codes.map do |discount_code|
        {
          name: discount_code.code,
          # ref: "",
          price_off: "#{discount_code.amount} #{currency || order.currency}"
        }
      end
    end

    def deals
      #TODO:
    end

    def customer
      #TODO:
    end

    def customer_list_id
      #TODO:
    end

    def customer_private_ref
      #TODO:
    end
  end
end
