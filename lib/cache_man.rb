# This file contains the main namespace of the gem
# and other required modules/classes needed by the rest of the gem
require "cache_man/version"
require "active_support/concern"
require "active_support/core_ext/numeric/time"
require "rails"

module CacheMan
end

require "cache_man/errors.rb"
require "cache_man/cacheable"
require "cache_man/fetchable"
