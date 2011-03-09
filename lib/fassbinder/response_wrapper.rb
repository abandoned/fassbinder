module Fassbinder
  class ResponseWrapper
    def initialize(response, locale)
      raise InvalidResponseError unless response.valid?

      @response = response
      @locale   = locale
    end

    # And I don't believe that melodramatic feelings are laughable -
    # they should be taken absolutely seriously.
    def items
      @response.map('Item') do |doc|
        Item.new(
          doc['ASIN'],
          doc['Offers']['TotalOffers'].to_i,
          doc['SalesRank'].to_i,
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
                                 Kosher::Location.new((doc['Merchant']['Location']['CountryCode'] rescue nil), (doc['Merchant']['Location']['StateCode'] rescue nil))),
              Kosher::Shipping.new(doc['OfferListing']['IsEligibleForSuperSaverShipping'] == '1' ?
                                     0 : (case @locale
                                          when :us then 399
                                          when :uk then 280
                                          when :de then 299
                                          when :ca then 649
                                          when :fr then 300
                                          when :jp then 25000
                                          end),
                                   doc['OfferListing']['Price']['CurrencyCode'],
                                   Kosher::Availability.new(doc['OfferListing']['AvailabilityAttributes']['MaximumHours'].to_i))
            )
          end
        )
      end
    end

    def errors
      @response.errors.map do |error|
        error['Message'].scan(/[0-9A-Z]{10}/).first rescue nil
      end.compact
    end

    def response
      @response
    end
  end
end
