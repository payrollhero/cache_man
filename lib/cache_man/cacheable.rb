# This concern adds support for memcache to a model.
# It depends on the memcache settings defined in your application to generate the client for accessing the memcache server.
# The concern allows one to cache an object, but for it to work, the object must respond to id and find methods.
module Cacheable
  extend ActiveSupport::Concern

  @cache_duration = 20.minutes

  class << self
    attr_reader :cache_duration
  end

  module ClassMethods
    def cache_client
      Dalli::Client.new
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
      cache_client.get(cache_key(id))
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
    self.cache_client.set(self.cache_key, self)
  end

  def stale?
    @cache_expires_at && Time.now > Time.at(@cache_expires_at)
  end

  def recache_later
    Rails.application.dispatch_publisher.publish(:subject => "recache_resource", :body => {:resource_type => self.class.name, :resource_id => self.id})
  end
end
