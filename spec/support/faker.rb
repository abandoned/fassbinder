module Faker
  module Amazon
    class << self
      def asin
        raw = 9.times.map { rand(10).to_s }
        (raw << Bookland::ISBN.new.send(:check_digit_10, raw)).join
      end

      def ean
        Bookland::ISBN.to_13(asin)
      end

      def merchant_id
        seed = ('A'..'Z').to_a + (0..9).to_a
        14.times.map { seed[rand(seed.size)] }.join
      end
    end
  end
end
