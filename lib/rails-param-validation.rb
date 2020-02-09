require_relative './rails-param-validation/version'

require_relative './rails-param-validation/types/types'

require_relative './rails-param-validation/validator_factory'

require_relative './rails-param-validation/validators/integer'
require_relative './rails-param-validation/validators/float'
require_relative './rails-param-validation/validators/boolean'
require_relative './rails-param-validation/validators/string'
require_relative './rails-param-validation/validators/uuid'
require_relative './rails-param-validation/validators/regex'
require_relative './rails-param-validation/validators/constant'
require_relative './rails-param-validation/validators/array'
require_relative './rails-param-validation/validators/object'
require_relative './rails-param-validation/validators/hash'
require_relative './rails-param-validation/validators/alternatives'

module RailsParamValidation
  ValidatorFactory.register IntegerValidatorFactory.new
  ValidatorFactory.register FloatValidatorFactory.new
  ValidatorFactory.register BooleanValidatorFactory.new
  ValidatorFactory.register StringValidatorFactory.new
  ValidatorFactory.register UuidValidatorFactory.new
  ValidatorFactory.register RegexValidatorFactory.new
  ValidatorFactory.register ObjectValidatorFactory.new
  ValidatorFactory.register ArrayValidatorFactory.new
  ValidatorFactory.register AlternativesValidatorFactory.new
  ValidatorFactory.register ConstantValidatorFactory.new
  ValidatorFactory.register HashValidatorFactory.new
end
