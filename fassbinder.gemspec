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
  s.summary     = %q{Wraps Amazon in a loving embrace.}
  s.description = %q{Fassbinder wraps Amazon in a loving embrace.}

  s.rubyforge_project = 'fassbinder'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('kosher', '~> 0.2.18')
  s.add_dependency('sucker', '~> 1.4.0')
  s.add_development_dependency('rspec', '~> 2.5.0')
  s.add_development_dependency('ruby-debug19', '~> 0.11.6')
  s.add_development_dependency('vcr', '~> 1.7.0')
  s.add_development_dependency('webmock', '~> 1.6.2')
end
