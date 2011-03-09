module Fassbinder
  class Book < Struct.new(:asin, :offers, :offers_count, :sales_rank)
    def self.build(doc)
      asin         = doc['ASIN']
      offers       = build_offers(doc['Offers']['Offer'])
      offers_count = doc['Offers']['TotalOffers'].to_i
      sales_rank   = doc['SalesRank'].to_i

      new(asin, offers, offers_count, sales_rank)
    end

    private

    def self.build_offers(offers)
      [offers].flatten.compact.map do |offer|

        # Because Ruby Money says so.
        if offer['OfferListing']['Price']['CurrencyCode'] == 'JPY'
          offer['OfferListing']['Price']['Amount'] = offer['OfferListing']['Price']['Amount'].to_i * 100
        end

        Offer.build(offer)
      end
    end
  end
end
