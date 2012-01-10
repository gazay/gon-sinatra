# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gon/sinatra/version"

Gem::Specification.new do |s|
  s.name        = "gon-sinatra"
  s.version     = Gon::Sinatra::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gazay']
  s.email       = ['alex.gaziev@gmail.com']
  s.homepage    = "https://github.com/gazay/gon-sinatra"
  s.summary     = %q{Get your Sinatra variables in your JS}
  s.description = %q{If you need to send some data to your js files and you don't want to do this with long way trough views and parsing - use this force!}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "rabl"
  s.add_dependency "sinatra"
  s.add_dependency "json"
  s.add_development_dependency "rspec"
end
