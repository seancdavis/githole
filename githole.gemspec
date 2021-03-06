# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'githole/version'

Gem::Specification.new do |spec|
  spec.name          = "githole"
  spec.version       = Githole::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]
  spec.summary       = %q{A simple git workflow to help develop for multiple releases.}
  spec.description   = %q{A wrapper for collections of git commands that make 
    it easy to develop for multiple releases concurrently. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
