require 'spec_helper'

module Fassbinder
  describe Request do
    let(:request) { Request.new(credentials) }

    describe ".new" do
      it "sets up an item request" do
        request.parameters['Operation'].should eql 'ItemLookup'
      end

      it "looks up ASINs" do
        request.parameters['ItemLookup.Shared.IdType'].should eql 'ASIN'
      end

      it "looks up all conditions" do
        request.parameters['ItemLookup.Shared.Condition'].should eql 'All'
      end

      it "looks up all merchants" do
        request.parameters['ItemLookup.Shared.MerchantId'].should eql 'All'
      end

      it "looks up full offers" do
        request.parameters['ItemLookup.Shared.ResponseGroup'].should eql ['OfferFull']
      end
    end

    describe "#batchify" do
      context "when passed one ASIN" do
        it "adds the ASIN to the batch" do\
          request.batchify('foo')
          request.parameters['ItemLookup.1.ItemId'].should eql ['foo']
        end
      end

      context "when passed up to 20 ASINs" do
        it "adds the ASINs to the batch" do
          asins = (0..19).to_a
          request.batchify(asins)

          request.parameters['ItemLookup.1.ItemId'].should eql (0..9).to_a
          request.parameters['ItemLookup.2.ItemId'].should eql (10..19).to_a
        end
      end

      context "when passed over 20 ASINs" do
        it "raises an error" do
          expect do
            asins = (0..20).to_a
            request.batchify(asins)
          end.to raise_error ArgumentError
        end
      end
    end

    describe "#get" do
      before do
        VCR.http_stubbing_adapter.http_connections_allowed = true
      end

      it "returns a response" do
        Request.stub!(:get)

        request.locale = :us
        request.batchify('foo')

        request.get.should be_a Response
      end
    end
  end
end
