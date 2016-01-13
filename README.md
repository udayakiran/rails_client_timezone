# rails_client_timezone
======================

The purpose of this gem is to track client's time zone for each request in the best possible way and run rails controller code in that time zone. Time zone can be tracked based on the ip OR browser's time zone OR a smarter combination of both.

# Instructions to use

## Installation -

#### As a stand alone gem - 

```
gem install rails_client_timezone
```

#### Using Gemfile -
```
gem 'rails_client_timezone', '~> 0.9.0'
```
OR from git source
```
  gem 'rails_client_timezone', '0.9.0', :git => 'https://github.com/udayakiran/rails_client_timezone'
```

## Usage -


 1) Create a file in your initializers and set the 'mode' to detect the time zone. This step is optional. Default value of mode is :smart .

``` 
# Say in config/initializers/rails_client_tz_init.rb
RailsClientTimezone::Setting.mode = :ip #default value is :smart. Accepted values - :browser, :ip, :smart 
```

**:ip** - Time zone will be detected based on the request's ip address(using geoip gem's logic)

**:browser** - Time zone will be detected based on browser utc offsets.

**:smart** - Time zone will be detected by browser if offsets are set or it falls back to ip(:browser mode first, which falls back to :ip mode).

 2) Include the around filter in every controller that needs to run code in user's timezone. If you need it for all controllers obviously add it to the application controller.

``` 
 prepend_around_filter RailsClientTimezone::Filter #Rails 4.1.x or earlier (inlcuding Rails 2,3 and 4)

 prepend_around_action RailsClientTimezone::Filter #Rails 4.2.x or later
```

#### For :browser and :smart mode -

Follow the below 2 steps if you are using :browser or :smart mode:

  a) Create a file in your initializers and set baseline year This step is optional. This means we are worried about time zone changes that occurred till this year. My suggestion is to keep this year same as either the year you are starting this project or the year when your rails version is released.
       Use "current" as the value if you want to stay on the edge. But, note that rails and your browsers need to be supporting this as well.

``` 
# Say in config/initializers/rails_client_tz_init.rb
RailsClientTimezone::Setting.baseline_year = 2014 #default value is 2011. Accepted values - any valid year or string - "current"
```

  b) Add the js code that sets the browser offsets in your js files. Code can be found in assets directory based on the js lib you use.
    If you use jquery, copy the js code from 'assets/set_browser_offset_cokies_jquery.js' and paste it in your js file which is inlcuded in every page.
    If you use prototypejs, copy the js code 'from assets/set_browser_offset_cokies_prototype.js' and paste it in your js file which is inlcuded in every page.

#### For :ip and :smart mode -

Follow the below step if you are using :ip or :smart mode:

  a) By default Geoip City db file is available in data directory, to override that db file you can download it from Download geoip city database from <geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz> and place anywhere in your app.
     Create a file in your initializers and set the geo ip city db file path. This step is optional.

``` 
# Say in config/initializers/rails_client_tz_init.rb

RailsClientTimezone::Setting.geoip_data_path = <file_path>  #Default path is <gem_source>/data/geoip/GeoLiteCity.dat
```

## Saving time zone in the database -

If you like to save the last_known_timezone of any user in the database, it can be done by accessing the cookie `:last_known_tz` any where in your controller.
so, `controller.cookies[:last_known_tz]` would give you the user's last know timezone name once `RailsClientTimezone::Filter` is done with the determining of the time zone from offsets.

## Practices in your code -

1. Use `Time.zone.*` not `Time.* ` -  Most of the scenarios we need to deal with times in the current time zone not in the system time zone on which app is running. So, we should use Time.zone.now, Time.zone.parse and time_obj.in_time_zone(Time.zone) when we are dealing with time information.

2. Use `Time.use_zone` -  When we need to operate in other time zones than the current system, enlose that code in Time.use_zone block. This sets back the system time zone once the code completes execution or even when exception occurs. Otherwise we should always remember to set the system's time zone back to default.

# To do -

 Add specs and tests.

# Contributors - 

Udayakiran

Yamini Devarajan

# Contributing -

Please help with your contribution by filing any issues if found. Pull requests are welcomed :)
