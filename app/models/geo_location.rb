class GeoLocation
  def self.text_search(text)
  end

  def self.long_lat_search(position)
  end

  def self.search(location)
    case location
      when String:
        text_search location
      when Array:
        long_lat_search location
    end
  end
end
