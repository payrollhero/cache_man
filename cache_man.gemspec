# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cache_man/version'

Gem::Specification.new do |spec|
  spec.name          = "cache_man"
  spec.version       = CacheMan::VERSION
  spec.authors       = ["Suman Mukherjee"]
  spec.email         = ["sumanmukherjee03@gmail.com"]
  spec.description   = %q{This is a gem that serves remote resources from a cache. If the cache gets stale, then the stale cache is served and the cache gets updated in async.}
  spec.summary       = %q{
    The gem connects to a memcache server and tries to fetch the resource you requested from the cache.
    It maintains a time stamp to figure out the expiry of the cache.
    But the expiry is a soft expiry in most cases.
    If it is a soft expiry, then it serves the stale asset and updates the cache in async.
    If it is a hard expiry, then it fetches the resource from remote and serves the asset.
  }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "dispatch-rider"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
