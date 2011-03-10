require 'spec_helper'

module Fassbinder
  describe Response do
    use_vcr_cassette 'batch-request'

    let(:asins) do
      # The last ASIN does not exist.
      %w{
        0816614024 0143105825 0485113600 0816616779 0942299078
        0816614008 144006654X 0486400360 0486417670 087220474X
        0486454398 0268018359 1604246014 184467598X 0312427182
        1844674282 0745640974 0745646441 0826489540 2081232191 }
    end

    let(:response) do
      request = Request.new(credentials)
      request.locale = :us
      request.batchify(asins)
      request.get
    end

    describe ".new" do
      it "raises an error if response is not valid" do
        response = mock('Response')
        response.stub!(:valid?).and_return(false)

        expect do
          Response.new(response, :us)
        end.to raise_error InvalidResponseError
      end
    end

    describe "#snapshots" do
      it "should return snapshots" do
        debugger
        response.snapshots.count.should eql 19
        response.snapshots.first.should be_a Kosher::Snapshot
      end
    end

    describe "#errors" do
      it "should return ASINs that are not found" do
        response.errors.count.should eql 1
        response.errors.first.should eql '2081232191'
      end
    end
  end
end
