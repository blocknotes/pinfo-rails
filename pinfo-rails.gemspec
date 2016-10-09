# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path( '../lib/', __FILE__ )
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?( lib )
require 'pinfo-rails'

Gem::Specification.new do |spec|
  spec.name        = PinfoRails::NAME
  spec.version     = PinfoRails::VERSION.join('.')
  spec.date        = PinfoRails::DATE
  spec.summary     = PinfoRails::INFO
  spec.description = PinfoRails::DESC
  spec.authors     = PinfoRails::AUTHORS.map { |a| a[0] }.flatten
  spec.email       = PinfoRails::AUTHORS.first[1]
  spec.files       = ['lib/pinfo-rails.rb']
  spec.homepage    =
    'http://rubygems.org/gems/pinfo-rails'
  spec.license     = 'MIT'
  spec.add_runtime_dependency 'colorize', '~> 0.8.0'
  spec.executables << 'pinfo'
end
