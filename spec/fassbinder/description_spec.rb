require 'spec_helper'

module Kosher
  describe Description do
    def this(value)
      Description.new(value)
    end

    it "inherits from String" do
      Description.ancestors.should include String
    end

    it "validates a blank description" do
      this('').should be_kosher
    end

    it "validates a non-blank description" do
      this('foo').should be_kosher
    end

    it "does not validate advance review copies" do
      this('Uncorrected review copy').should_not be_kosher
      this('arc').should_not be_kosher
      this('arc.').should_not be_kosher

      this('marc').should be_kosher
    end

    it "does not validate marked books" do
      this('Some highlighting').should_not be_kosher
      this('Underlining.').should_not be_kosher
      this('Good. Hiliting.').should_not be_kosher

      this('No highlighting.').should be_kosher
    end

    it "does not validate books with missing volumes" do
      this('First vol only.').should_not be_kosher
    end

    it "does not validate damaged or worn books" do
      this('Different').should be_kosher
      this('Rental').should_not be_kosher
      this('Torn pages').should_not be_kosher
    end

    it "does not validate withdrawn library copies" do
      this('xlib').should_not be_kosher
      this('ex-library').should_not be_kosher
      this('retired library copy').should_not be_kosher

      this('Not an ex-library').should be_kosher
    end
  end
end
