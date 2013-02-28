# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'sysmocom_stock'
  s.version     = '0.0.1'
  s.summary     = 'sysmocom s.f.m.c. Stock Management'
  s.description = 'Help estimating empty stock, turnover'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Holger Hans Peter Freyther'
  #s.email     = 'you@example.com'
  s.homepage  = 'http://www.sysmocom.de'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 1.2.0'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sqlite3'
end
