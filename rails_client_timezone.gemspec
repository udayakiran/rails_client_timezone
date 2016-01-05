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
    lib/rails_client_timezone/filter.rb
    lib/rails_client_timezone/version.rb
    lib/rails_client_timezone/setting.rb
    lib/rails_client_timezone/active_support.rb
    lib/geoip.rb
    rails_client_timezone.gemspec
  ]
  s.require_paths = ["lib"]

  s.add_runtime_dependency "activesupport", '> 2'
  s.add_runtime_dependency "geoip", '1.6.1'
end