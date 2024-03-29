module RailsParamValidation

  class MatchResult
    attr_reader :errors, :matching, :value

    def initialize(value, path = nil, error = nil)
      @value = value
      @errors = []

      unless error.nil?
        @errors.push(path: path, message: error)
      end

      @matching = error.nil?
    end

    def matches?
      @matching
    end

    # @param [MatchResult] other
    # @return [MatchResult]
    def merge!(other)
      @matching = @matching && other.matching
      @errors += other.errors

      self
    end

    def error_messages
      @errors.map { |e| { path: e[:path].join('/'), message: e[:message] } }
    end
  end

  class Validator
    attr_reader :schema, :collection

    def initialize(schema, collection)
      @schema = schema
      @collection = collection
    end

    # @return [MatchData]
    def matches?(path, structure)
    end

    def to_openapi
      raise NotImplementedError
    end
  end

end