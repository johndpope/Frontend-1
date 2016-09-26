# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frontend/version'

Gem::Specification.new do |spec|
  spec.name          = "frontend"
  spec.version       = Frontend::VERSION
  spec.authors       = ["Pedro Piñera Buendía"]
  spec.email         = ["pepibumur@gmail.com"]
  spec.summary       = %q{Downloads a frontend and zips it to be used with the frontend manager}
  spec.homepage      = "https://github.com/pepibumur/frontend"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency 'rubyzip', '>= 1.0.0'
  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
end
