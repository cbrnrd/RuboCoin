# RuboCoin

RuboCoin is my attempt of a cryptocurrency. I created it mainly just to learn more about blockchain technology.
This gem is the full node you can run on your machine to mine rubocoin and handle transactions


## Installation

You have 2 ways to get the rubocoin node (`rubocoind`). You can grab the source code
or you can download the gem from (RubyGems)[https://rubygems.org].

#### Installing from source

```
$ git clone https://github.com/cbrnrd/RuboCoin
$ bundle install
$ bundle exec bin/rubocoind
```

#### Installing via `gem`

```
$ gem install rubocoin
$ rubocoind
```

## Usage

All you have to do is open port 44856 and run `rubocoind`.

More command line options are coming in the near future.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cbrnrd/RuboCoin.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
