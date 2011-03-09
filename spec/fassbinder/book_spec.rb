require 'spec_helper'

module Kosher
  describe Item do
    it "should descend from Kosher::Struct" do
      Item.ancestors.should include Kosher::Struct
    end

    describe ".build" do
      use_vcr_cassette '0143105825'

      let(:asin) { '0143105825' }

      it "should build an item" do
        request = Request.new(credentials)
        request.locale = :us
        request.batchify([asin])
        algorithm = request.get
        response = algorithm.instance_variable_get(:@response)
        doc = response.find('Item').first
        item = Item.build(doc)

        item.should be_a Item
        item.asin.should eql asin
        item.offers_count.should be > 0
        item.sales_rank.should be > 0
        item.offers.count.should > 0
        item.offers.first.should be_a Offer
      end

      it "should senify Yen in Japanese requests" do
        request = Request.new(credentials)
        request.locale = :jp
        request.batchify([asin])
        algorithm = request.get
        response = algorithm.instance_variable_get(:@response)
        doc = response.find('Item').first

        doc['Offers']['Offer'].each do |offer|
          offer['OfferListing']['Price']['Amount'] = 1
        end
        item = Item.build(doc)

        item.offers.each do |offer|
          offer.cents.should eql 100
        end
      end
    end
  end
end
