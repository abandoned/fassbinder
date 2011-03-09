module Kosher
  class Description < String
    DAMAGED     = "\\b(?:missing|torn|broken|split|discard|withdrawn|rent|stain|school|damaged|water)"
    EXLIB       = "(?:e?x|discarded|retired|former|has|have)[\\s._-]*lib"
    MARKED      = "(highlight|hilit|underlin)"
    MISSING_VOL = "(vols?|volume) only"
    REVIEW_COPY = "\\b(?:uncorrected|advanced?\\sreview|arc)\\b"

    def kosher?
      !(present? && bad?)
   end

    private

    def bad?
      damaged?        ||
      ex_library?     ||
      marked?         ||
      missing_volume? ||
      review_copy?
    end

    def damaged?
      matches(DAMAGED)
    end

    def does_not_match(value)
      !match(Regexp.new(value, true))
    end

    def ex_library?
      matches(EXLIB) && does_not_match(negation_of(EXLIB))
    end

    def marked?
      matches(MARKED) && does_not_match(negation_of(MARKED))
    end

    def matches(value)
      !does_not_match(value)
    end

    def missing_volume?
      matches(MISSING_VOL)
    end

    def negation_of(value)
      "(?:no|not an?)\\s+#{value}"
    end

    def present?
      self != ''
    end

    def review_copy?
      matches(REVIEW_COPY)
    end
  end
end
