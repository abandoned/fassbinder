module Fassbinder
  class Request < Sucker::Request
    def initialize(args = {})
      super
      self.<<({
        'Operation'                       => 'ItemLookup',
        'ItemLookup.Shared.IdType'        => 'ASIN',
        'ItemLookup.Shared.Condition'     => 'All',
        'ItemLookup.Shared.MerchantId'    => 'All',
        'ItemLookup.Shared.ResponseGroup' => ['OfferFull', 'SalesRank'] })
    end

    def batchify(asins)
      self.<<({ 'ItemLookup.1.ItemId' => asins[0, 10] })
      self.<<({ 'ItemLookup.2.ItemId' => asins[10, 10] }) if asins.size > 10
    end

    def get
      Algorithm.new(super)
    end
  end
end
