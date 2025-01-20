class GeocodeService
  include HTTParty
  base_uri "https://geocode.xyz"

  def initialize(address)
    @address = address
  end

  def fetch_location
    response = self.class.get("/#{URI.encode_www_form_component(@address)}?json=1")
    return nil if error_response?(response) || throttled_response?(response)

    {
      title: @address,
      latitude: response["latt"],
      longitude: response["longt"]
    }
  end

  def throttled_response?(response)
    latitude = response["latt"]
    latitude.is_a?(String) && latitude.include?("Throttled!")
  end

  def error_response?(response)
    response["error"] || !response.success?
  end
end
