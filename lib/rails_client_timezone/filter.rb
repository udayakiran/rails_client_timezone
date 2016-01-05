# Runs the controller code in the user's time zone which is determined through the offsets passed via cookies.
module RailsClientTimezone
  class Filter
    
    def self.filter(controller, &block)
      cookies = controller.send(:cookies)
      
      current_time_zone = if Setting.mode == :browser
        get_time_zone_by_browser_offset(cookies[:utc_offset_summer], cookies[:utc_offset_winter], cookies[:last_known_tz])
      elsif Setting.mode == :ip
        get_time_zone_by_ip(controller, cookies[:last_known_tz])
      else
        get_time_zone_by_smart(controller, cookies[:utc_offset_summer], cookies[:utc_offset_winter], cookies[:last_known_tz])
      end
      controller.response.set_cookie(:last_known_tz, {:path => "/", :value => current_time_zone.name})
    
      Time.use_zone(current_time_zone) do
        yield
      end
    end
    
    # Returns the time zone based on parsed *utc_offset_summer* and *utc_offset_winter*
    # Returns the default TimeZone if none is resolved
    def self.get_time_zone_by_browser_offset(utc_offset_summer, utc_offset_winter, last_known_tz)
      # ActiveSupport::TimeZone[offset] - will return the first time zone that matches the offset.
      # But, we need to get the exact time zone inorder to reflect the daylight savings.
      # So, we get the user's time zone exactly by matching the summer offset and winter offset both.
      [ActiveSupport::TimeZone[last_known_tz.to_s], ActiveSupport::TimeZone.all].flatten.compact.detect(ifnone = Time.method(:zone_default)) do |zone|
        Time.use_zone(zone.name) do
          if utc_offset_summer.present? && utc_offset_winter.present?
            (Time.zone.parse(Setting.mid_summer_date_str).utc_offset == utc_offset_summer.to_i && Time.zone.parse(Setting.mid_winter_date_str).utc_offset == utc_offset_winter.to_i)
          else
            (Time.zone.name == last_known_tz.to_s)
          end
        end
      end
    end
    
    # Returns the time zone based on IP address
    # Returns the default TimeZone if none is resolved
    def self.get_time_zone_by_ip(controller, last_known_tz = nil)
      return ActiveSupport::TimeZone[last_known_tz] if last_known_tz && ActiveSupport::TimeZone[last_known_tz]
      begin
        ip_addr = controller.request.remote_ip
        geo_timezone = GeoIP.new('GeoLiteCity.dat').city(ip_addr) ? GeoIP.new('GeoLiteCity.dat').city(ip_addr).timezone : nil
        timezone_name = geo_timezone && ActiveSupportExt.format(geo_timezone) ? ActiveSupportExt.format(geo_timezone) : Time.zone_default.name
      rescue Exception => e
        ActiveSupport::TimeZone[Time.zone_default.name]
      end
      ActiveSupport::TimeZone[timezone_name]
    end
    
    # Returns the time zone using both ip address and browser offset
    # Returns the default TimeZone if none is resolved
    def self.get_time_zone_by_smart(controller, utc_offset_summer, utc_offset_winter, last_known_tz)
      last_known_tz_val = last_known_tz ? last_known_tz : get_time_zone_by_ip(controller).name
      get_time_zone_by_browser_offset(utc_offset_summer, utc_offset_winter, last_known_tz_val)
    end
  end
end