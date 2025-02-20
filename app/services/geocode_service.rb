class GeocodeService
  include HTTParty
  base_uri "https://geocode.xyz"

  def initialize(address)
    @address = address
  end

  def fetch_location
    response = self.class.get(build_uri_path)
    return nil if error_response?(response) || throttled_response?(response)

    {
      latitude: response["latt"],
      longitude: response["longt"]
    }
  end

  private

  def build_uri_path
    geocode_api_key = Rails.application.credentials.geocode_api_key
    "/#{URI.encode_www_form_component(@address)}?json=1&auth=#{geocode_api_key}"
  end

  def throttled_response?(response)
    latitude = response["latt"]
    latitude.is_a?(String) && latitude.include?("Throttled!")
  end

  def error_response?(response)
    response["error"] || !response.success?
  end
end
