module CacheMan
  class CacheManError < StandardError
  end

  class FinderNotFound < CacheManError
    def initialize
      super("There is no <model>.find method defined. Please implement a <model>.find method or a finder module in app/models/<model>/finder.rb")
    end
  end
end
