require 'spec_helper'

module Fassbinder
  describe Marketplace do
    describe ".uri_builder" do
      let(:uri) { Marketplace.uri_builder('US', '0195019199') }

      context "given a known country and valid ASIN" do
        subject { uri }
        it      { should eq 'http://www.amazon.com/gp/offer-listing/0195019199/sr=/qid=/ref=olp_tab_all?ie=UTF8' }
      end
    end
  end
end
