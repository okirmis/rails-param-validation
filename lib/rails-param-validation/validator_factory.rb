require_relative "./errors/no_matching_factory"
require_relative "./validator"

module RailsParamValidation

  class ValidatorFactory

    # @param [ValidatorFactory] factory
    def self.register(factory)
      factories.push factory
    end

    # @return [Array<ValidatorFactory>]
    def self.factories
      @@factories ||= []
    end

    # @return [Validator]
    def self.create(schema)
      factory = factories.detect { |f| f.supports? schema }

      if factory.nil?
        raise NoMatchingFactory.new(schema)
      end

      factory.create schema
    end

    # @return [Boolean]
    def supports?(schema)
    end

    # @return Validator
    def create(schema)
    end
  end
end
