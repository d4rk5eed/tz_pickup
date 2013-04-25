# TzPickup

## Description

Simple tool for picking up timezone identifier 
using geographic coordinates. 

## Installation

Add this line to your application's Gemfile:

    gem 'tz_pickup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tz_pickup

Run:

	$ bundle exec tz_pickup charge

for charging with new zone.tab

## Usage

* **TzPickup.tz_pickup(latitude, longitude)** returns timezone identifier,
`latitude`, `longitude` -  are coordinates of the zone's principal location
in ISO 6709 sign-degrees-minutes-seconds format,
either +-DDMMSS+-DDMMSS or +-DDMMSS+-DDDMMSS,
first latitude (+ is north), then longitude (+ is east).

For example:

```ruby
TzPickup.tz_pickup(554500, 373600)
 => "Europe/Moscow" 
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

=======
tz_pickup
=========

tz_pickup
