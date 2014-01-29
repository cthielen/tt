# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttr/version'

Gem::Specification.new do |spec|
  spec.name          = "ttr"
  spec.version       = Ttr::VERSION
  spec.authors       = ["Christopher Thielen"]
  spec.email         = ["cthielen@gmail.com"]
  spec.description   = %q{tt is a simple CLI time-tracker.}
  spec.summary       = %q{tt is a simple time-tracker.}
  spec.homepage      = "http://christopher.thielen.co/projects/tt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "activerecord", "~> 3.2"
  spec.add_dependency "sqlite3", "~> 1.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
end
