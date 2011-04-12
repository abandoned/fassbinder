require 'spec_helper'

describe "Smokescreen" do
  use_vcr_cassette 'smokescreen', :record => :all

  let(:request) do
    Fassbinder::Request.new(credentials)
  end

  it "works" do
    request.locale = :us
    request.batchify(['0091929784'])
    response = request.get
    debugger
    puts response.to_a
  end
end
