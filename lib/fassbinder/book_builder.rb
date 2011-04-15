require 'kosher'
require 'fassbinder/offer_builder'

module Fassbinder
  class BookBuilder
    attr_reader :book

    def initialize
      @book = Kosher::Book.new
      @book.offers = []
    end

    def add_offer(hash)
      builder = OfferBuilder.new
      builder.id = hash['OfferListing']['OfferListingId']
      builder.venue = @book.venue
      builder.add_item(hash)
      builder.add_seller(hash['Merchant'])
      builder.add_shipping(hash)
      @book.offers << builder.offer
    end

    def asin=(asin)
      @book.asin = asin
    end

    def venue=(venue)
      @book.venue = venue
    end

    def offers_total=(count)
      @book.offers_total = count.to_i
    end
  end
end
