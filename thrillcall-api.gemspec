# -*- encoding: utf-8 -*-
require File.expand_path("../lib/thrillcall-api/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "thrillcall-api"
  s.version     = ThrillcallAPI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dan Healy"]
  s.email       = ["dan@thrillcall.com"]
  s.homepage    = "http://rubygems.org/gems/thrillcall-api"
  s.summary     = "Simple wrapper around http://www.thrillcall.com's API"
  s.description = "Simple wrapper around http://www.thrillcall.com's API"
  
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "thrillcall-api"
  
  s.add_development_dependency  "bundler",                ">= 1.0.0"
  s.add_development_dependency  "rspec",                  "~> 2.1.0"
  s.add_development_dependency  "ZenTest",                "~> 4.4.0"
  s.add_development_dependency  "autotest",               "~> 4.4.2"
  s.add_development_dependency  "autotest-growl",         "~> 0.2.6"
  s.add_development_dependency  "autotest-fsevent",       "~> 0.2.3"
  s.add_development_dependency  "awesome_print",          "~> 0.3.2"
  s.add_development_dependency  "redcarpet",              "~> 1.17.2"
  s.add_development_dependency  "nokogiri",               "~> 1.4.6"
  s.add_development_dependency  "albino",                 "~> 1.3.3"
  #s.add_development_dependency  "jekyll",                 "~> 0.10.0"
  
  s.add_dependency              "faraday",                "~> 0.7.0"
  #s.add_dependency              "faraday_middleware",     "~> 0.6.3"
  #s.add_dependency              "multi_json",             "~> 1.0.3"
  #s.add_dependency              "hashie",                 "~> 1.0.0"
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
