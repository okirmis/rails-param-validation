require_relative 'lib/rails-param-validation/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-param-validation"
  spec.version       = RailsParamValidation::VERSION
  spec.authors       = ["Oskar Kirmis"]
  spec.email         = ["oskar.kirmis@posteo.de"]

  spec.summary       = "Automatically validate rails parameter types"
  spec.description   = "Automatically validate rails parameter types"
  spec.homepage      = "https://git.iftrue.de/okirmis/rails-param-validation"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://git.iftrue.de/okirmis/rails-param-validation"
  spec.metadata["changelog_uri"] = "https://git.iftrue.de/okirmis/rails-param-validation"

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `find .`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
