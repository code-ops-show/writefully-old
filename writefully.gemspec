  $:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "writefully/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "writefully"
  s.version     = Writefully::VERSION
  s.authors     = ["Zack Siri"]
  s.email       = ["zack@artellectual.com"]
  s.homepage    = "http://www.codemy.net"
  s.summary     = %q{Makes publishing content easier by using black magic}
  s.description = %q{Allows developer to quickly publish to their site using git hooks}
  s.license     = "MIT"

  s.files       = Dir["{app,config,db,lib,scripts,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.executables = ["writefully"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency 'rails', '>= 4'
  s.add_dependency 'coffee-rails', '~> 4.0'
  s.add_dependency 'sass-rails', '~> 4.0'
  s.add_dependency 'sprockets',  '= 2.11.0'
  
  s.add_dependency 'celluloid'
  s.add_dependency 'fog'
  s.add_dependency 'unf'
  s.add_dependency 'listen', '~> 2.0'
  s.add_dependency 'thor'
  s.add_dependency 'pg'
  s.add_dependency 'hashie'
  s.add_dependency 'friendly_id'
  s.add_dependency 'github_api'
  s.add_dependency 'connection_pool'
  s.add_dependency 'redis'
  s.add_dependency 'redis-namespace'
  s.add_dependency 'activerecord-import'

  s.add_dependency 'jquery-rails'
  s.add_dependency 'turbolinks'
  s.add_dependency 'transponder'
  s.add_dependency 'bootstrap-sass'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
end
