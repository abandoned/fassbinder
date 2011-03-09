module Fassbinder
  class Algorithm
    def initialize(response)
      raise InvalidResponseError unless response.valid?

      @response = response
    end

    def books
      @response.map('Item') do |item|
        Book.build(item)
      end
    end

    def errors
      @response.errors.map do |error|
        error['Message'].scan(/[0-9A-Z]{10}/).first rescue nil
      end.compact
    end

    def response
      @response
    end
  end
end
