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
      title: get_title_from_response(response),
      latitude: response["latt"].to_f,
      longitude: response["longt"].to_f,
      postal_code: response["standard"]["postal"]
    }
  end

  def get_title_from_response(response)
    data = response['standard']
    "#{data["postal"]}: #{data["city"]}, #{data["region"]}, #{data["countryname"]}"
  end

  def throttled_response?(response)
    postal = response["postal"]
    postal.is_a?(String) && postal.include?("Throttled!")
  end

  def error_response?(response)
    response["error"] || !response.success?
  end
end
