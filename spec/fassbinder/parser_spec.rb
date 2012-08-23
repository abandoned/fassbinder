require 'spec_helper'

module Fassbinder
  describe Parser, :vcr do
    let(:request)   { Request.new("US", "0195019199") }
    let(:body)      { request.get.body }
    let(:parsed)    { Parser.new(body) }

    describe "#offer_list" do
      subject { parsed.offer_list }
      it      { should have(15).offers }
    end

    describe "#offer" do
      context "given Amazon is the merchant" do
        let(:listing) { parsed.offer_list.first }

        it "should have offer listing details" do
          listing['OfferListing']['Price'].should eq 3634
          listing['OfferListing']['Quantity'].should eq 1
          listing['OfferListing']['OfferListingId'].should have_at_least(100).characters
        end

        it "should have offer attributes" do
          listing['OfferAttributes']['SubCondition'] = "new"
        end

        it "should have merchant details" do
          listing['Merchant']['MerchantId'].should eq 'ATVPDKIKX0DER'
          listing['Merchant']['Name'].should eq "Amazon.com"
        end
      end
    end
  end
end
