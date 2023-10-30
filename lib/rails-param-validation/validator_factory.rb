require_relative "./errors/no_matching_factory"
require_relative "./validator"

module RailsParamValidation

  class FactoryCollection
    # @return [Array<ValidatorFactory>]
    attr_reader :factories

    # @param [Array<ValidatorFactory>] factories
    def initialize(factories = [])
      @factories = factories
    end

    def register(factory)
      factories.push factory
    end

    def clone
      FactoryCollection.new(factories.clone)
    end
  end

  class ValidatorFactory

    # @param [ValidatorFactory] factory
    def self.register(factory)
      collection.register factory
    end

    # @return [FactoryCollection]
    def self.collection
      @factories ||= FactoryCollection.new
    end

    # @return [Validator]
    def self.create(schema, collection = self.collection)
      factory = collection.factories.detect { |f| f.supports? schema }

      if factory.nil?
        raise NoMatchingFactory.new(schema)
      end

      factory.create schema, collection
    end

    # @return [Boolean]
    def supports?(schema)
    end

    # @return Validator
    def create(schema, collection)
    end
  end
end
