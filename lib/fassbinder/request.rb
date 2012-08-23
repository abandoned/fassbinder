require 'typhoeus'
require 'fassbinder/response'
require 'fassbinder/marketplace'

module Fassbinder
  class Request
    attr_reader :url, :country

    def initialize(country, asin)
      @country = country
      @uri     = Marketplace.uri_builder(@country, asin)
    end

    def get
      Response.new(build_request, @country)
    end

   def build_request
     Typhoeus::Request.get(@uri, params)
   end

   def params
     { headers: { 'User-Agent' => "IE!" } }
   end
  end
end
