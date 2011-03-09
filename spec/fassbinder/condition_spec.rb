require 'spec_helper'

module Kosher
  describe Condition do
    describe "#to_i" do
      def this(str)
        Condition.new(str).to_i
      end

      it "casts as integer" do
        this('new').should eql 1
        this('mint').should eql 2
        this('verygood').should eql 3
        this('good').should eql 4
        this('acceptable').should eql 5
      end

      it "casts unrecognized conditions as 6" do
        this('refurbished').should eql 6
      end
    end

    describe "#kosher?" do
      it "returns true if condition is good or better" do
        Condition.new('verygood').should be_kosher
        Condition.new('good').should be_kosher
        Condition.new('acceptable').should_not be_kosher
      end
    end
  end
end
