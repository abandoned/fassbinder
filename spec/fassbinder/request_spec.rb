require 'spec_helper'
require 'pry'

module Fassbinder
  describe 'Request', :vcr do
    let(:request) { Request.new("US", "0195019199") }

    describe "#new" do
      subject { request }
      it      { should be_a Request }
    end

    describe "#get" do
      subject { request.get }
      it      { should be_a Response }
    end
  end
end
