$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "rails"
require "active_resource"
require "webmock/rspec"
require "cache_man.rb"

module CacheMan
  class Application < ::Rails::Application
    config.eager_load = false
  end
end

CacheMan::Application.initialize!

RSpec.configure do |config|
  config.before do
    Rails.cache.clear
  end

  config.before(:suite) do
    FileUtils.mkdir_p(Rails.root + "tmp/cache")
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root + "tmp/cache")
  end

  config.mock_with :rspec
  config.order = 'random'
  config.color_enabled = true
  config.tty = true
end
