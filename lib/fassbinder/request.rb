require 'sucker'
require 'fassbinder/response'

module Fassbinder
  class Request < Sucker::Request
    def initialize(args = {})
      super
      self.<<({
        'Operation'                       => 'ItemLookup',
        'ItemLookup.Shared.IdType'        => 'ASIN',
        'ItemLookup.Shared.Condition'     => 'All',
        'ItemLookup.Shared.MerchantId'    => 'All',
        'ItemLookup.Shared.ResponseGroup' => ['OfferFull'] })
    end

    def batchify(asins)
      asins = [asins].flatten

      if asins.size > 20
        raise ArgumentError, 'You cannot add more than 20 ASINs to a batch'
      end

      self.<<({ 'ItemLookup.1.ItemId' => asins[0, 10] })
      self.<<({ 'ItemLookup.2.ItemId' => asins[10, 10] }) if asins.size > 10
    end

    def get
      Response.new(super, locale)
    end
  end
end
