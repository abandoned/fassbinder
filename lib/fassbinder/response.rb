require 'fassbinder/book_builder'
require 'fassbinder/errors'

module Fassbinder
  class Response
    include Enumerable

    def initialize(response, locale)
      raise InvalidResponse, response.body unless response.valid?

      @response = response
      @locale   = locale.to_sym
    end

    # Yields each snapshot to given block.
    #
    def each(&block)
      @response.each('Item') { |doc| block.call(build_book(doc)) }
    end

    def errors
      @response.errors.map do |error|
        error['Message'].scan(/[0-9A-Z]{10}/).first rescue nil
      end.compact
    end

    private

    def build_book(doc)
      builder = BookBuilder.new

      builder.asin = doc['ASIN']
      builder.offers_total = doc['Offers']['TotalOffers']
      host = Sucker::Request::HOSTS[@locale]
      builder.venue = host.sub('ecs.amazonaws', 'amazon')

      offers = [doc['Offers']['Offer']].flatten.compact
      offers.each { |offer| builder.add_offer(offer) }

      builder.book
    end
  end
end
