# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy-ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "fuzzy-ruby"
  spec.version       = FuzzyRuby::VERSION
  spec.authors       = ["Ben Weissmann"]
  spec.email         = ["ben@benweissmann.com"]

  spec.summary       = %q{Auto-correct your Ruby code using fuzzy matching.}
  spec.homepage      = "https://github.com/benweissmann/fuzzy-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "amatch", "~> 0.3.0"
  spec.add_runtime_dependency "binding_of_caller", "~> 0.7.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
