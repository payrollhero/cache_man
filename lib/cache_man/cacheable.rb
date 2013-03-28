# This concern adds support for getting and setting cache for a model.
# It also adds support for a soft expiry of cache besides a hard expiry.
# The module allows an object to respond to the stale? method which informs other objects whether the cache has soft expired or not.
# The cache can be updated asynchronously if it has soft expired.
# For the asynchronously update of the cache, this gem depends on another gem called dispatch_rider.
# It depends on the cache settings defined in your application config to work properly.
# The concern only works for ducks that respond to id and find methods.
# So, ideally any ActiveModel or ActiveResource object should work.
module CacheMan
  module Cacheable
    extend ActiveSupport::Concern

    @cache_duration = 20.minutes

    class << self
      attr_reader :cache_duration
    end

    module ClassMethods
      def cache_client
        Rails.cache
      end

      def cache_key(id)
        "#{self.name.underscore}/#{id}"
      end

      def cache(id)
        resource = find(id)
        resource.cache
        resource
      end
      alias_method :new_cache, :cache

      def get_cached(id)
        cache_client.read(cache_key(id))
      end
    end

    def cache_client
      self.class.cache_client
    end

    def cache_key
      self.class.cache_key(self.id)
    end

    def cache
      @cache_expires_at = Cacheable.cache_duration.since.to_i
      self.cache_client.write(self.cache_key, self)
    end

    def stale?
      @cache_expires_at && Time.now > Time.at(@cache_expires_at)
    end

    def recache_later
      Rails.application.dispatch_publisher.publish(:subject => "recache_resource", :body => {:resource_type => self.class.name, :resource_id => self.id})
    end
  end
end
