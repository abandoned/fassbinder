require 'spec_helper'

module Kosher
  describe Offer do
    let(:offer) { Fabricate(:offer) }

    describe ".build" do
      use_vcr_cassette '0143105825'

      let(:asin) { '0143105825' }

      let(:doc) do
        request = Request.new(credentials)
        request.locale = :us
        request.batchify([asin])
        algorithm = request.get

        response = algorithm.instance_variable_get(:@response)
        response.find('Offer').first
      end

      it "should build an offer" do
        offer = Offer.build(doc)

        offer.should be_a Offer
        expect do
          offer.kosher?
        end.should_not raise_error
      end

      it "populates the offer listing ID" do
        offer = Offer.build(doc)
        offer.listing_id.should_not be_nil
      end

      it "populates the exchange ID" do
        offer = Offer.build(doc)
        offer.exchange_id.should_not be_nil
      end

      it "should handle blank descriptions" do
        doc['OfferAttributes']['ConditionNote'] = ''
        offer = Offer.build(doc)

        offer.description.should eql ''
      end
    end

    describe "#kosher?" do
      context "when condition is kosher" do
        before do
          offer.condition = Fabricate(:kosher_condition, :grade => 1)
        end

        context "when seller is kosher" do
          before do
            offer.seller = Fabricate(:good_seller)
          end

          context "when description is kosher" do
            context "when offer ships now" do
              it "returns true" do
                offer.should be_kosher
              end
            end

            context "when offer does not ship now" do
              before do
                offer.ships_in = 96
              end

              it "returns false" do
                offer.should_not be_kosher
              end
            end
          end

          context "when description is not kosher" do
            before do
              offer.description = Kosher::Description.new("Withdrawn library book")
            end

            it "returns false" do
              offer.should_not be_kosher
            end
          end
        end

        context "when seller is not kosher" do
          before do
            offer.seller = Fabricate(:bad_seller)
          end

          it "returns false" do
            offer.should_not be_kosher
          end
        end
      end

      context "when condition is not kosher" do
        before do
          offer.condition = Fabricate(:kosher_condition, :grade => 5)
        end

        it "returns false" do
          offer.should_not be_kosher
        end
      end
    end

    describe "#ships_now?" do
      context "when offer ships within 48 hours" do
        before do
          offer.ships_in = 48
        end

        it "returns true" do
          offer.send(:ships_now?).should be_true
        end
      end

      context "when offer ships in over 48 hours" do
        before do
          offer.ships_in = 96
        end

        it "returns false" do
          offer.send(:ships_now?).should be_false
        end
      end
    end
  end
end
