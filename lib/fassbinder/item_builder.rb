module Fassbinder
  class ItemBuilder
    attr_reader :item

    def initialize
      @item = Kosher::Item.new
    end

    def price=(price)
      cents    = price['Amount'].to_i
      currency = price['CurrencyCode']

      cents *= 100 if currency == 'JPY'

      @item.cents    = cents
      @item.currency = currency
    end

    def quantity=(quantity)
      @item.quantity = quantity.to_i
    end

    def add_condition(grade)
      condition = Kosher::Condition.new
      condition.grade =
        case grade
        when 'new'        then 1
        when 'mint'       then 2
        when 'verygood'   then 3
        when 'good'       then 4
        when 'acceptable' then 5
        else 6
        end

      @item.condition = condition
    end

    def add_description(text)
      text ||= ''
      description = Kosher::Description.new
      description.text = text

      @item.description = description
    end
  end
end
