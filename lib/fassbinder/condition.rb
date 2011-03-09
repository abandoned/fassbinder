module Fassbinder
  class Condition < Kosher::Condition
    AMAZON_CONDITIONS = {
      'new'        => 1,
      'mint'       => 2,
      'verygood'   => 3,
      'good'       => 4,
      'acceptable' => 5 }

    def self.build(condition)
      self.grade = CONDITIONS[string] || 6
    end
  end
end
