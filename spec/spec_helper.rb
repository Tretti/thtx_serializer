# encoding: utf-8

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name 'spec:unit'

    add_filter 'config'
    add_filter 'vendor'
    add_filter 'spec'

    minimum_coverage 98.5
  end
end

require 'devtools'
require 'thtx_serializer'

RSpec.configure do |config|
  config.expect_with :rspec do |expect_with|
    expect_with.syntax = :expect
  end
end
