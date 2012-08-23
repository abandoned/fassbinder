require 'spec_helper'

module Fassbinder
  describe Response do
    let(:response) do
      request = Request.new('US', '0195019199')
      request.get
    end

    describe ".new" do
      context "when response is not valid" do
        it "raises an error" do
          response = mock('Response')
          response.stub!(:success?).and_return(false)

          expect do
            Response.new(response, 'US')
          end.to raise_error InvalidResponse
        end
      end
    end

    describe "#to_a", :pending do
      it "returns an array of books" do
        books = response.to_a

        books.count.should eql 19
        books.first.should be_a Kosher::Book
      end
    end
  end
end
