require 'spec_helper'

module Kosher
  describe Struct do
    before(:all) do
      class Foo < Struct.new(:bar); end
    end

    describe "to_json" do
      it "converts to JSON" do
        foo = Foo.new
        foo.bar = 1

        foo.to_json.should eql "{\"bar\":1}"
      end

      it "handles nested structs" do
        foo_1 = Foo.new
        foo_2 = Foo.new

        foo_2.bar = 1
        foo_1.bar = foo_2

        foo_1.to_json.should eql "{\"bar\":{\"bar\":1}}"
      end
    end
  end
end
