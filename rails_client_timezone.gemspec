# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_client_timezone/version"

Gem::Specification.new do |s|
  s.name        = "rails_client_timezone"
  s.version     = RailsClientTimezone::VERSION
  s.authors     = ["Udaya Kiran", "Yamini Devarajan"]
  s.email       = ["udaykiran.vit@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Rails Browser Timezone client gem}
  s.description = %q{Simple code to detect browser time zone and handle it in rails app}
  
  s.rubyforge_project = "rails_client_timezone"

  s.files         = %w[
    Gemfile
    README.md
    LICENSE.md
    lib/rails_client_timezone/filter.rb
    lib/rails_client_timezone/version.rb
    lib/rails_client_timezone/setting.rb
    lib/rails_client_timezone/active_support_ext.rb
    lib/geoip.rb
    lib/rails_client_timezone.rb
    data/geoip/country_code.yml
    data/geoip/country_code3.yml
    data/geoip/country_continent.yml
    data/geoip/country_name.yml
    data/geoip/GeoLiteCity.dat
    data/geoip/region.yml
    data/geoip/time_zone.yml
    assets/set_browser_offset_cookies_jquery.js
    assets/set_browser_offset_cookies_prototype.js
    rails_client_timezone.gemspec
  ]
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activesupport", '> 2'
  s.add_runtime_dependency "geoip", '1.6.1'
end
