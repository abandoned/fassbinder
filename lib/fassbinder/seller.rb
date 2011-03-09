module Fassbinder
  class Seller < Kosher::Seller
    class << self
      def build(doc)
        id     = doc['MerchantId']
        name   = doc['Name']
        rating = doc['AverageFeedbackRating'].to_f

        new(id, name, rating)
      end
    end
  end
end
