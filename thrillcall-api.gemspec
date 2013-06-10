# -*- encoding: utf-8 -*-
require File.expand_path("../lib/thrillcall-api/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "thrillcall-api"
  s.version     = ThrillcallAPI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dan Healy", "Eddy Kang", "Glenn Rempe"]
  s.email       = ["github@thrillcall.com"]
  s.homepage    = "https://github.com/thrillcall/thrillcall-api"
  s.summary     = "Simple wrapper around http://thrillcall.com's API"
  s.description = "Simple wrapper around http://thrillcall.com's API"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "thrillcall-api"

  s.add_development_dependency  "bundler",                ">= 1.0.0"
  s.add_development_dependency  "rake",                   "~> 0.9.2.2"
  s.add_development_dependency  "rspec",                  "~> 2.7.0"
  s.add_development_dependency  "ZenTest",                "~> 4.6.2"
  s.add_development_dependency  "autotest",               "~> 4.4.6"
  s.add_development_dependency  "autotest-growl",         "~> 0.2.16"
  s.add_development_dependency  "autotest-fsevent",       "~> 0.2.8"
  s.add_development_dependency  "awesome_print",          "~> 1.0.1"
  s.add_development_dependency  "redcarpet",              "~> 1.17.2"
  s.add_development_dependency  "nokogiri",               "~> 1.4.6"
  s.add_development_dependency  "albino",                 "~> 1.3.3"
  s.add_development_dependency  "faker",                  "~> 0.9.5"
  s.add_development_dependency  "tzinfo",                 "~> 0.3.31"

  s.add_dependency              "faraday",                "~> 0.8.7"
  s.add_dependency              "retriable",              "~> 1.3.3"

  s.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.require_path = 'lib'
end
