# coding: UTF-8
#require File.expand_path('../lib/tam/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name = "tam"
  s.version = "0.0.1"#TAM::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.authors = ["Carlos Manzanares"]
  s.email = ["developers@telcoassetmarketplace.com"]
  s.homepage = "https://github.com/tamdeveloper/telco-asset-marketplace-gem"
  s.description = %q{The Ruby gem for the telco asset marketplace REST APIs}
  s.summary = "telco asset marketplace Ruby gem"
  s.rubyforge_project = s.name

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  
  s.require_path = 'lib'
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")  

  s.post_install_message =<<eos
********************************************************************************

  Visit our community pages for up-to-date information
  https://code.telcoassetmarketplace.com/

********************************************************************************  
eos
end