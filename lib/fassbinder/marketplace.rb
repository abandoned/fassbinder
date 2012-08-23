module Marketplace
  class UnknownCountry < StandardError; end
  def self.uri_builder(country, asin)
    uri = 'http://www.amazon.'
    uri += case country
             when 'US' then 'com'
             when 'CA' then 'ca'
             when 'UK' then 'co.uk'
             when 'DE' then 'de'
             when 'ES' then 'es'
             when 'CN' then 'cn'
             when 'IT' then 'it'
             when 'FR' then 'fr'
             when 'JP' then 'co.jp'
             else raise UnknownCountry
           end
    uri += "/gp/offer-listing/#{asin}/sr=/qid=/ref=olp_tab_all?ie=UTF8"
  end
end
