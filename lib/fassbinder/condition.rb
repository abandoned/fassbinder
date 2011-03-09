module Kosher
  class Condition < Struct.new(:grade)

    alias_method :to_i, :grade

    CONDITIONS = {
      'new'        => 1,
      'mint'       => 2,
      'verygood'   => 3,
      'good'       => 4,
      'acceptable' => 5 }

    def initialize(string = '')
      self.grade = CONDITIONS[string] || 6
    end

    def kosher?
      grade <= 4
    end

    def new?
      grade == 1
    end

    def used?
      !new?
    end
  end
end
