# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "request_log/version"

Gem::Specification.new do |s|
  s.name        = "request_log"
  s.version     = RequestLog::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Marklund"]
  s.email       = ["peter@marklunds.com"]
  s.homepage    = ""
  s.summary     = %q{Rack middleware for logging web requests to a MongoDB database. Provides a profiler for monitoring logging overhead.}

  s.rubyforge_project = "request_log"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec", "2.0.0"
  s.add_development_dependency "mocha", "~> 0.9.8"
  s.add_development_dependency "rack", "~> 2.0.8"
end
