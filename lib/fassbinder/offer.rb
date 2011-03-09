module Kosher
  class Offer < Struct.new(
    :seller,
    :condition,
    :description,
    :ships_in,
    :ships_free,
    :cents,
    :exchange_id,
    :listing_id)

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

    def kosher?
      condition.kosher? && seller.kosher? && description.kosher? && ships_now?
    end

    def ships_now?
      ships_in.to_i <= 48
    end
  end
end
