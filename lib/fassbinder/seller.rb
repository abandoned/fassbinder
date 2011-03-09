module Kosher
  class Seller < Struct.new(:merchant_id, :name, :average_rating)
    class << self
      attr_accessor :blacklist

      def build(doc)
        merchant_id    = doc['MerchantId']
        name           = doc['Name']
        average_rating = doc['AverageFeedbackRating'].to_f

        new(merchant_id, name, average_rating)
      end
    end

    def blacklist
      self.class.blacklist
    end

    def blacklisted?
      blacklist.include?(merchant_id) rescue false
    end

    def kosher?
      return false if blacklisted?

      average_rating == 0.0 || average_rating > 4.7
    end
  end
end
