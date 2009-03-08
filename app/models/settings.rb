# Internal settings
class Settings
  @@loaded = false
  @@config = []

  class << self
    def [](group)
      load_config unless @@loaded
      @@config[group]
    end

    private
      def load_config
        @@loaded = true
        @@config = YAML.load(File.open("#{RAILS_ROOT}/config/settings.yml"))
      end
      
      def method_missing(sym, *args)
        Settings[sym.to_s][args.first]
      end
  end
end

