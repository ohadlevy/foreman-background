$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'foreman_background/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'foreman_background'
  s.version     = ForemanBackground::VERSION
  s.authors     = ['Ohad Levy']
  s.email       = ['ohadlevy@gmail.com']
  s.homepage    = 'http://theforeman.org'
  s.summary     = 'Adds background processing via sidekiq to foreman'
  s.description = 'Adds background processing via sidekiq to foreman'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'sidekiq'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rake'
end
