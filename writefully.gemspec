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

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 4.0.4'
  s.add_dependency 'celluloid',  '~> 0.15.2'
  s.add_dependency 'activerecord-import'
  s.add_dependency 'listen', '~> 2.0'
  s.add_dependency 'thor'
  s.add_dependency 'pg'
  s.add_dependency 'hashie'
  s.add_dependency 'sinatra'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
end
