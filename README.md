# Sophos::SG::Rest

This gem implements a simple rest client for the SOPHOS SG REST API. The client
will help building [Chef](https://www.chef.io/), [Puppet](https://puppet.com/)
or other integration and provisioning scripts.

## Installation

Add this line to your application's Gemfile:

    gem 'sophos-sg-rest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sophos-sg-rest

## Usage

Simple example on how to get started:

    client = described_class.new('https://<user>:<pass>@<host>/api/',
                                 fingerprint: 'F3:D3:C6:C2:01:93:4A:BC:87:C4:07:8D:10:5A:59:F3:B0:B0:3C:XX')
    hosts = client.objects('network/host')

More documentation can be found at [rubydoc](http://www.rubydoc.info/gems/sophos-sg-rest)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sophos-iaas/ruby-sophos-sg-rest.

