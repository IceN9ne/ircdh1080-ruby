# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ircdh1080/version'

Gem::Specification.new do |spec|
  spec.name          = "ircdh1080"
  spec.version       = IrcDH1080::VERSION
  spec.authors       = ["IceN9ne"]
  spec.email         = ["IceN9ne.code@gmail.com"]

  spec.summary       = %q{Ruby Diffie-Hellman 1080 Key-Exchange Module for IRC}
  spec.description   = %q{A Ruby module for handling DH1080 key exchange for IRC}
  spec.homepage      = "https://github.com/JasonIverson/ircdh1080-ruby/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -z {test,spec,features}/*`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.requirements << 'openssl'
end
