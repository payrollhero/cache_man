# This concern adds support for a model to be fetched either from memcache or from some other data store.
# The concern is only to be included in classes that implement a class method find to fetch the object from a data store other than cache.
# If such a class method does not exist, you can write your own custom finder module for the model.
# By convention, the finder module should be app/models/<model_name>/finder.rb
# The first attempt to fetch a model will be from memcache.
# If that fails, then it will fallback to fetching from a different data store.
module Fetchable
  extend ActiveSupport::Concern

  included do
    include Cacheable
    begin
      extend "#{name}::Finder".constantize
    rescue NameError => ex
      raise "You should define #{name}.find for this module to work!" unless respond_to?(:find)
    end
    private_class_method :find
  end

  module ClassMethods
    def fetch(id)
      cached_resource = get_cached(id)
      if cached_resource
        cached_resource.recache_later if cached_resource.stale?
      else
        cached_resource = new_cache(id)
      end
      cached_resource
    end
  end
end
