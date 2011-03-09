require 'spec_helper'

module Fassbinder
  describe Seller do
    use_vcr_cassette '0143105825'

    describe ".build" do
      before do
        request = Request.new(credentials)
        request.locale = :us
        request.batchify ['0143105825']
        @doc = request.get.response.find('Merchant').first
      end

      it "populates the id" do
        seller = Seller.build(@doc)
        seller.id.should_not be_nil
      end

      it "populates the name" do
        seller = Seller.build(@doc)
        seller.name.should_not be_nil
      end

      it "populates the rating" do
        seller = Seller.build(@doc)
        seller.rating.should be_an_instance_of Float
      end

      it "builds a newly-launched seller" do
        @doc['AverageFeedbackRating'] = '0.0'
        seller = Seller.build(@doc)
        seller.rating.should eql 0.0
      end
    end
  end
end
