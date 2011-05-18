module Fassbinder
  class ShippingBuilder
    DEFAULT_SHIPPING_CENTS = { 'amazon.com'   => 399,
                               'amazon.co.uk' => 280,
                               'amazon.de'    => 299,
                               'amazon.ca'    => 649,
                               'amazon.fr'    => 300,
                               'amazon.co.jp' => 25000 }

    attr_reader :shipping

    def initialize
      @shipping = Kosher::Shipping.new
    end

    def add_availability(hours, preorder)
      availability = Kosher::Availability.new
      availability.hours = hours.to_i
      availability.preorder = (preorder == "1" ? true : false)
      @shipping.availability = availability
    end

    def calculate_price(is_free, venue, currency)
      @shipping.cents = is_free ? 0 : DEFAULT_SHIPPING_CENTS[venue]
      @shipping.currency = currency
    end
  end
end
