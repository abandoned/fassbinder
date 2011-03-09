module Fassbinder
  class Offer < Kosher::Offer
    def self.build(doc)
      offer             = new
      offer.seller      = Seller.build(doc['Merchant'])

      attributes        = doc['OfferAttributes']
      offer.condition   = Condition.new(attributes['SubCondition'])
      offer.description = Description.new(attributes['ConditionNote'].to_s)

      listing           = doc['OfferListing']
      offer.ships_in    = listing['AvailabilityAttributes']['MaximumHours'].to_i
      offer.ships_free  = listing['IsEligibleForSuperSaverShipping'] == '1'
      offer.cents       = listing['Price']['Amount'].to_i
      offer.exchange_id = listing['ExchangeId']
      offer.listing_id  = listing['OfferListingId']

      offer
    end
  end
end
