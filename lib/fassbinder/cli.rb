require 'pp'
require 'thor'
require 'fassbinder'

module Fassbinder
  class CLI < Thor
    desc 'all', 'Looks up all offers for an ASIN'
    method_option :locale, :required => true, :aliases => '-l'
    def all(asin)
      locale = options[:locale] || :us
      lookup(asin, locale)
    end
    map 'a' => 'all'

    desc 'kosher', 'Looks up kosher offers for an ASIN'
    method_option :locale, :required => true, :aliases => '-l'
    def kosher(asin)
      locale = options[:locale] || :us
      lookup(asin, locale, true)
    end
    map 'k' => 'kosher'

    private

    def lookup(asin, locale, kosher_only=false)
      request = Request.new(credentials)
      request.locale = locale
      request.batchify(asin)
      offers = request.get.to_a.first.offers

      offers.select!(&:kosher?) if kosher_only

      offers.each do |offer|
        puts offer.kosher? ? 'kosher' : 'unkosher'

        offer.id = offer.id[0, 24] + '...'

        description = offer.item.description.text
        if description.size > 77
          offer.item.description.text = description[0, 77] + '...'
        end

        pp offer
        puts
      end
    end
    def credentials
      { 'key'    => ENV['AMAZON_KEY'],
        'secret' => ENV['AMAZON_SECRET'] }
    end
  end
end
