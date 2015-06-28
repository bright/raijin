# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raijin/version'

Gem::Specification.new do |spec|
  spec.name          = 'raijin'
  spec.version       = Raijin::VERSION
  spec.authors       = ['Piotr Mionskowski']
  spec.email         = ['piotr.mionskowski@gmail.com']
  spec.summary       = %q{Send data from ruby profiler for further processing}
  spec.description   = %q{}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-prof', '~> 0.15.1'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'ruby-debug-ide', '~> 0.4.0'
  spec.add_development_dependency 'debase', '~> 0.1.4'
end
