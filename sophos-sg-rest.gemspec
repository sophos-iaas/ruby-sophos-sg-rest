# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sophos/sg/rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'sophos-sg-rest'
  spec.version       = Sophos::SG::REST::VERSION
  spec.authors       = ['Vincent Landgraf']
  spec.email         = ['sophos-iaas-oss@sophos.com']
  spec.licenses      = ['MIT', 'SOPHOS proprietary']

  spec.summary       = %q{SOPHOS SG UTM Series - REST API Client Library}
  spec.homepage      = "https://github.com/sophos-iaas/ruby-sophos-sg-rest"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.12'
end
