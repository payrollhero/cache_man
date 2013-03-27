module CacheMan
  class Railtie < ::Rails::Railtie
    config.cache_store = :dalli_store, 'localhost:11211', {:namespace => "CacheMan::#{Rails.env}", :expires_in => 1.day, :compress => true}
  end
end
