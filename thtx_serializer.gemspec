# encoding: utf-8

require File.expand_path('../lib/thtx_serializer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'thtx_serializer'
  gem.version = THTXSerializer::VERSION
  gem.authors = [ 'Björn Skarner' ]
  gem.email = [ 'bjorn.skarner@it.cdon.com' ]
  gem.description = 'Serialize ruby objects from a hash to xml.'
  gem.summary = gem.description
  gem.homepage = 'https://github.com/Tretti/thtx_serializer'
  gem.license = 'MIT'

  gem.require_paths = %w[lib]
  gem.files = `git ls-files`.split($/)
  gem.test_files = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'nokogiri', '>= 1.5'
  gem.add_runtime_dependency 'gyoku', '~> 1.1.1'
  gem.add_runtime_dependency 'activesupport', '>= 3.2.17'

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'pry', '~> 0.9.12'
  gem.add_development_dependency 'awesome_print', '~> 1.2.0'
end
