module RailsClientTimezone  
  class Setting
   class << self
      attr_writer :baseline_year
      attr_writer :mode
      attr_writer :geoip_data_path
      
      #Possible mode values - :ip, :browser, :smart
      def mode
        @mode ||= :smart 
      end
      
      def geoip_data_path
        @geoip_data_path ||= File.expand_path(File.join(File.dirname(__FILE__), '../..', 'data/geoip', 'GeoLiteCity.dat'))
      end
      
      def baseline_year
        @baseline_year ||= 2011
      end
      
      def mid_summer_date_str
        "#{year}-6-21"
      end
      
      def mid_winter_date_str
        "#{year}-12-21"
      end
      
      def year
        (baseline_year.to_sym == :current) ? Time.zone.now.year : baseline_year
      end
   end
  end
end