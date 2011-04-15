module Fassbinder
  class SellerBuilder
    attr_reader :seller

    def initialize
      @seller = Kosher::Seller.new
    end

    def id=(id)
      @seller.id = id
    end

    def name=(name)
      @seller.name = name
    end

    def rating=(rating)
      @seller.rating = rating.to_f
    end

    def add_location(hash)
      location = Kosher::Location.new
      location.country = hash['CountryCode']
      location.state = hash['StateCode']
      @seller.location = location
    end
  end
end
