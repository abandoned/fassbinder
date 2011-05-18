require 'fassbinder/item_builder'
require 'fassbinder/seller_builder'
require 'fassbinder/shipping_builder'

module Fassbinder
  class OfferBuilder
    attr_reader :offer

    def initialize
      @offer = Kosher::Offer.new
    end

    def add_item(hash)
      builder = ItemBuilder.new
      builder.price = hash['OfferListing']['Price']
      builder.quantity = hash['OfferListing']['Quantity']
      builder.add_condition(hash['OfferAttributes']['SubCondition'])
      builder.add_description(hash['OfferAttributes']['ConditionNote'])
      @offer.item = builder.item
    end

    def add_seller(hash)
      builder = SellerBuilder.new
      builder.id = hash['MerchantId']
      builder.name = hash['Name']
      builder.rating = hash['AverageFeedbackRating']
      builder.add_location(hash['Location']) if hash['Location']
      @offer.seller = builder.seller
    end

    def add_shipping(hash)
      builder = ShippingBuilder.new
      builder.add_availability(
        hash['OfferListing']['AvailabilityAttributes']['MaximumHours'],
        hash['OfferListing']['AvailabilityAttributes']['IsPreorder']
      )
      is_free = (hash['OfferListing']['IsEligibleForSuperSaverShipping'] == '1')
      builder.calculate_price(is_free, @offer.venue, hash['OfferListing']['Price']['CurrencyCode'])
      @offer.shipping = builder.shipping
    end

    def id=(id)
      @offer.id = id
    end

    def venue=(venue)
      @offer.venue = venue
    end
  end
end
