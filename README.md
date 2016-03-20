# GitPlist

A git diff-filter for OS X `*.plist` files.  Handy for using git with `~/Library/Preferences`.

(Note:  I don't recommend this as a strategy for versioning your machine configuration, but being able to see changes here can be useful for discovering what keys to use with the `defaults` command...)


## Installation

```bash
sudo gem install git_plist

git config --global filter.plist.clean git-plist-clean
git config --global filter.plist.smudge "git-plist-smudge %f"
```


## Usage

In a git repository:

```bash
echo '*.plist filter=plist' >> .gitattributes
git add .gitattributes
git commit -m "Enable git-plist filter on *.plist."
```


## Development

See [[DEVELOPMENT.md]] for details.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MrJoy/git_plist.

Before submitting pull requests, I would appreciate it greatly if you run `rake lint:rubocop`, and try to ensure your code adheres to the style configuration.  PRs will not be rejected for lack of this, but not doing this creates more work for me which makes it harder for me to accept contributions.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

