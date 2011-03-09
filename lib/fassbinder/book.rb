module Kosher
  class Book < Struct.new(:asin, :offers, :offers_count, :sales_rank)

    class << self
      def build(doc)
        asin         = doc['ASIN']
        sales_rank   = doc['SalesRank'].to_i
        offers_count = doc['Offers']['TotalOffers'].to_i
        offers       = build_offers(doc['Offers']['Offer'])

        new(asin, offers, offers_count, sales_rank)
      end

      private

      def build_offers(offers)
        [offers].flatten.compact.map do |offer|

          # Senify Yen because Ruby Money says so
          if offer['OfferListing']['Price']['CurrencyCode'] == 'JPY'
            offer['OfferListing']['Price']['Amount'] = offer['OfferListing']['Price']['Amount'].to_i * 100
          end

          Offer.build(offer)
        end
      end
    end
  end
end
