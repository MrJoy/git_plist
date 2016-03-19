# GitPlist

A git diff-filter for OS X `*.plist` files.  Handy for using git with `~/Library/Preferences`.

(Note:  I don't recommend this as a strategy for versioning your machine configuration, but being able to see changes here can be useful for discovering what keys to use with the `defaults` command...)


## Installation

```bash
sudo gem install git_plist

# TODO: Add relevant `git config` statements here...
```


## Usage

TODO: Add instructions for `.gitattributes` file here.


## Development

__NOTE: I strongly recommend using RVM or rbenv + rbenv-gemsets.__

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec git_plist` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MrJoy/git_plist.

Before submitting pull requests, I would appreciate it greatly if you run `rake lint:rubocop`, and try to ensure your code adheres to the style configuration.  PRs will not be rejected for lack of this, but not doing this creates more work for me which makes it harder for me to accept contributions.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

