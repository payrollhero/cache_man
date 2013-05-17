# CacheMan

This gem helps you to cache your resources. The gem allows a soft expiry
of the cache. If the cache soft expires, it serves the stale resource,
but tries to fetch the current resource via an async process. As of now,
it works with Rails cache.

## Build status

[![Build Status](https://travis-ci.org/payrollhero/cache_man.png)](https://travis-ci.org/payrollhero/cache_man)

## Installation

Add this line to your application's Gemfile:

    gem 'cache_man'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cache_man

## Usage

```ruby
  class Test < ActiveResource::Base
    include CacheMan::Fetchable
  end

  Test.fetch(1) # when invoked the first time, goes and fetches the resource from a remote location.
  # After sometime we try to fetch the resource again
  Test.fetch(1) # will return the value from the cache
  # As of now, the soft expiration for the cache is hard coded to 20 mins
  # We assume that your Rails cache expires after that
  # After 20 mins
  Test.fetch(1) # Still return the cached data, but spins an sysnc process to fetch the fresh data
```

We are going to remove the hard coded expiry time and make it more configurable.
Although the example is demonstrated with ActiveResource, the gem works
for any class that responds to a find method.
So, basically the example
would still work if the Test class inherited from ActiveRecord::Base.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright (c) 2013 Suman Mukherjee

MIT License

For more information on license, please look at LICENSE.txt
