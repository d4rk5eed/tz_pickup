# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tz_pickup/version'

Gem::Specification.new do |spec|
  spec.name          = "tz_pickup"
  spec.version       = TzPickup::VERSION
  spec.authors       = ["Yaroslav Zemlyanukhin"]
  spec.email         = ["y.zemlyanukhin@mdterra.org"]
  spec.description   = %q{Simple tool for picking up timezone identifier using geographic coordinates.}
  spec.summary       = %q{Timezone pick up utility}
  spec.homepage      = "https://github.com/d4rk5eed/tz_pickup"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mocha"

  spec.post_install_message = File.read('USAGE')

  spec.add_dependency "kdtree"
  spec.add_dependency "thor"
  spec.add_dependency "colorize"
end
