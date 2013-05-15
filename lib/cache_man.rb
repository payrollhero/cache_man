require "cache_man/version"
require "active_support/concern"
require "active_support/core_ext/numeric/time"
require "dalli"

module CacheMan
end

require "cache_man/cacheable"
require "cache_man/fetchable"
