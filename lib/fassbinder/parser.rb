require 'nokogiri'
require "pry"
module Fassbinder
  class Parser
    class UnknownAmazonSite < StandardError; end
    attr_reader :doc, :offers

    def initialize(body)
      @doc    = Nokogiri::HTML(body)
      offer_list
    end

    def offer_list
      @doc.search("tbody.result").collect do |offer_node|
        offer(offer_node)
      end
    end

    def offer(offer_node)
      result = {}

      form_node = offer_node.at('td.readytobuy form')

      result['OfferListing'] = {}
      result['OfferListing']['Price'] = price(offer_node.at('span.price').text)
      result['OfferListing']['Quantity'] = form_node.at('input[type="hidden"][name="itemCount"]').attr('value').to_i
      result['OfferListing']['OfferListingId'] = form_node.at('input[type="hidden"][name="offeringID.1"]').attr('value')

      result['OfferAttributes'] = {}
      result['OfferAttributes']['SubCondition'] = offer_node.at('div.condition').text.downcase

      merchant_node = offer_node.at("ul.sellerInformation")

      result['Merchant'] = {}
      result['Merchant']['Name'] = merchant_name(merchant_node)
      result['Merchant']['MerchantId'] = merchant_id(result['Merchant']['Name'])
      result
    end

    def price(price_node_text)
      price_match = price_node_text.match(/([\d,\.]+)/i)
      price_match[1].delete(",.").to_i
    end

    def merchant_name(merchant_node)
      if amazon_site = merchant_node.at("img").attr("title")
        amazon_site
      else
        merchant_node.at("a b").text
      end
    end

    def merchant_id(merchant_name)
      if merchant_name =~ /(Amazon\.(com|co\.uk|ca|de|fr|co\.jp))/
        case merchant_name
          when "Amazon.com"   then "ATVPDKIKX0DER"
          when "Amazon.co.uk" then "A3P5ROKL5A1OLE"
          when "Amazon.ca"    then "A3DWYIK6Y9EEQB"
          when "Amazon.de"    then "A3JWKAKR8XB7XF"
          when "Amazon.fr"    then "A1X6FK5RDHNB96P"
          when "Amazon.co.jp" then "AN1VRQENFRJN5"
          else raise UnknownAmazonSite
        end
      else
      end
    end
  end
end
