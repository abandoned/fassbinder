require 'spec_helper'

module Fassbinder
  describe Request do
    let(:request) { Request.new(credentials) }

    describe ".new" do
      it "defines a batch request" do
        request.parameters['Operation'].should eql 'ItemLookup'
        request.parameters['ItemLookup.Shared.IdType'].should eql 'ASIN'
        request.parameters['ItemLookup.Shared.Condition'].should eql 'All'
        request.parameters['ItemLookup.Shared.MerchantId'].should eql 'All'
        request.parameters['ItemLookup.Shared.ResponseGroup'].should eql ['OfferFull', 'SalesRank']
      end
    end

    describe "#batchify" do
      it "adds up to 20 ASINs to the worker's parameters" do
        asins = (0..19).to_a
        request.batchify(asins)

        request.parameters['ItemLookup.1.ItemId'].should eql (0..9).to_a
        request.parameters['ItemLookup.2.ItemId'].should eql (10..19).to_a
      end
    end

    describe "#get" do
      before do
        VCR.http_stubbing_adapter.http_connections_allowed = true
      end

      it "returns an algorithm" do
        Request.stub!(:get)

        request.locale = :us
        request.batchify('foo')

        request.get.should be_a ResponseWrapper
      end
    end
  end
end
