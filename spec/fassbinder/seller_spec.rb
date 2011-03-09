require 'spec_helper'

module Kosher
  describe Seller do
    describe ".build" do
      use_vcr_cassette '0143105825'

      let(:asin) { '0143105825' }

      let(:response) do
        request = Request.new(credentials)
        request.locale = :us
        request.batchify([asin])
        algorithm = request.get

        algorithm.instance_variable_get(:@response)
      end

      let(:seller) do
        docs = response.find('Merchant')
        Seller.build(docs.first)
      end

      it "populates the merchant ID of a seller" do
        seller.merchant_id.should match /^[0-9A-Z]{13,14}$/
      end

      it "populates the name of a seller" do
        seller.name.should_not be_nil
      end

      it "populates the average rating of a seller" do
        seller.average_rating.should be_an_instance_of Float
      end

      it "builds a newly-launched seller" do
        doc = response.find('Merchant').detect { |doc| doc["AverageFeedbackRating"] == "0.0" }
        new_seller = Seller.build(doc)

        new_seller.average_rating.should eql 0.0
      end
    end

    describe "#kosher?" do
      it "returns true if seller's average rating is 0.0" do
        seller = Fabricate(:new_seller)
        seller.should be_kosher
      end

      it "returns true if seller's average rating is above 4.7" do
        seller = Fabricate(:good_seller)
        seller.should be_kosher
      end

      it "returns false if sellers' average rating is 4.7 or below" do
        seller = Fabricate(:bad_seller)
        seller.should_not be_kosher
      end

      it "returns false if seller is blacklisted" do
        seller = Fabricate(:good_seller)
        seller.should be_kosher

        seller.merchant_id = Faker::Amazon.merchant_id
        Seller.blacklist = [seller.merchant_id]

        seller.should_not be_kosher
      end
    end
  end
end
