# Development

## Setup

__NOTE: I strongly recommend using RVM or rbenv + rbenv-gemsets.__

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec git_plist` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Updating Test Fixtures

1. Edit the `_xml1.plist` versions of the relevant fixture(s).
1. Commit your changes to those files.
1. `rake update_fixtures`
1. Commit changes to all fixtures.  Note that the XML versions may have changed -- be sure the changes are only in formatting/ordering, and if so, commit those.
1. `rake update_results`
1. Ensure the results are correct, and commit changes to modified `*.clean` files.
