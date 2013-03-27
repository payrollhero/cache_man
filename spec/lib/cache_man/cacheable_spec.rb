require 'spec_helper'

describe Cacheable do
  class CacheableTestDummy
    include Cacheable
    attr_accessor :id

    def initialize(attrs = {})
      attrs.each do |(key, val)|
        self.__send__("#{key.to_s}=".to_sym, val)
      end
    end

    def self.find(id)
      self.new(:id => id)
    end

    def attributes
      {:id => id}
    end

    def ==(other)
      other.respond_to?(:attributes) && attributes == other.attributes
    end
  end

  subject do
    CacheableTestDummy.new(:id => 1)
  end

  describe "cache_duration" do
    it "should return the duration for which the cache is valid" do
      Cacheable.cache_duration.should eq(20.minutes)
    end
  end

  describe ".cache_client" do
    it "should return a client to access the cache" do
      CacheableTestDummy.cache_client.is_a?(Dalli::Client).should be_true
    end
  end

  describe ".cache_key" do
    it "should return the key where the cached value is stored" do
      CacheableTestDummy.cache_key(1).should eq('cacheable_test_dummy/1')
    end
  end

  describe ".cache" do
    it "should find the object and cache it" do
      CacheableTestDummy.cache(1)
      result = CacheableTestDummy.cache_client.get('cacheable_test_dummy/1')
      result.should_not be_stale
      result.should eq(subject)
    end
  end

  describe "#cache_client" do
    it "should return a client to access the cache" do
      subject.cache_client.is_a?(Dalli::Client).should be_true
    end
  end

  describe "#cache_key" do
    it "should return the key where the cached value is stored" do
      subject.cache_key.should eq('cacheable_test_dummy/1')
    end
  end

  describe "#cache" do
    it "should cache the object with a soft expiry time" do
      subject.cache
      result = CacheableTestDummy.cache_client.get('cacheable_test_dummy/1')
      result.should_not be_stale
      result.should eq(subject)
    end
  end
end
