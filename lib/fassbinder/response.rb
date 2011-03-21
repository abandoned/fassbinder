module Fassbinder

  # And I don't believe that melodramatic feelings are laughable - they should
  # be taken absolutely seriously.
  #
  class Response
    include Enumerable

    DEFAULT_SHIPPING_CENTS = { :us => 399,
                               :uk => 280,
                               :de => 299,
                               :ca => 649,
                               :fr => 300,
                               :jp => 25000 }

    def initialize(response, locale)
      raise InvalidResponseError unless response.valid?

      @response = response
      @locale   = locale
    end

    # Yields each snapshot to given block.
    #
    def each(&block)
      @response.each('Item') { |doc| block.call(parse(doc)) }
    end

    def errors
      @response.errors.map do |error|
        error['Message'].scan(/[0-9A-Z]{10}/).first rescue nil
      end.compact
    end

    private

    def parse(doc)
      Kosher::Book.new(
        'amazon.' + Sucker::Request::HOSTS[@locale].match(/[^.]+$/).to_s,
        nil,
        doc['ASIN'],
        doc['SalesRank'].to_i,
        doc['Offers']['TotalOffers'].to_i,
        [doc['Offers']['Offer']].flatten.compact.map do |doc|
          if doc['OfferListing']['Price']['CurrencyCode'] == 'JPY'
            doc['OfferListing']['Price']['Amount'] = doc['OfferListing']['Price']['Amount'].to_i * 100
          end

          Kosher::Offer.new(
            doc['OfferListing']['OfferListingId'],
            Kosher::Item.new(doc['OfferListing']['Price']['Amount'].to_i,
                             doc['OfferListing']['Price']['CurrencyCode'],
                             doc['OfferListing']['Quantity'].to_i,
                             Kosher::Condition.new(case doc['OfferAttributes']['SubCondition']
                                                   when 'new'        then 1
                                                   when 'mint'       then 2
                                                   when 'verygood'   then 3
                                                   when 'good'       then 4
                                                   when 'acceptable' then 5
                                                   else 6
                                                   end),
                             Kosher::Description.new(doc['OfferAttributes']['ConditionNote'].to_s)),
            Kosher::Seller.new(doc['Merchant']['MerchantId'],
                               doc['Merchant']['Name'],
                               doc['Merchant']['AverageFeedbackRating'].to_f,
                               Kosher::Location.new((doc['Merchant']['Location']['CountryCode'] rescue nil),
                                                    (doc['Merchant']['Location']['StateCode'] rescue nil))),
            Kosher::Shipping.new(doc['OfferListing']['IsEligibleForSuperSaverShipping'] == '1' ?
                                   0 : DEFAULT_SHIPPING_CENTS[@locale],
                                 doc['OfferListing']['Price']['CurrencyCode'],
                                 Kosher::Availability.new(doc['OfferListing']['AvailabilityAttributes']['MaximumHours'].to_i))
          )
        end
      )
    end
  end
end
