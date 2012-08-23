require 'fassbinder/book_builder'
require 'fassbinder/errors'
require 'fassbinder/parser'

module Fassbinder
  class Response
    attr_reader :body

    def initialize(response, locale)
      raise InvalidResponse, response unless response.success?
      @body = response.body
      doc = Fassbinder::Parser.new(@body)
      build_book(doc)
    end

    private

    def build_book(doc)
      #builder = BookBuilder.new

      #builder.asin = doc['ASIN']
      #builder.offers_total = doc['Offers']['TotalOffers']
      #host = Sucker::Request::HOSTS[@locale]
      #builder.venue = host.sub('ecs.amazonaws', 'amazon')

      #offers = [doc['Offers']['Offer']].flatten.compact
      #offers.each { |offer| builder.add_offer(offer) }

      #builder.book
    end
  end
end
