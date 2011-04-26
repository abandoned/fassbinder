# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'fassbinder/version'

Gem::Specification.new do |s|
  s.name        = 'fassbinder'
  s.version     = Fassbinder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paper Cavalier']
  s.email       = 'code@papercavalier.com'
  s.homepage    = 'https://rubygems.org/gems/fassbinder'
  s.summary     = %q{Crawls book offers on Amazon}
  s.description = %q{Fassbinder crawls book offers on Amazon.}

  s.rubyforge_project = 'fassbinder'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('kosher', '~> 0.2.23')
  s.add_dependency('sucker', '~> 1.5.0.1')
  s.add_dependency('thor', '~> 0.14.6')
end
