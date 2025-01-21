class GeocodeService
  include HTTParty
  base_uri "https://geocode.xyz"

  def initialize(address)
    @address = address
  end

  def fetch_location
    auth_key = ENV["GEOCODE_AUTH_KEY"] # or use Rails Encrypted Credentials (https://edgeguides.rubyonrails.org/security.html#custom-credentials)
    response = self.class.get("/#{URI.encode_www_form_component(@address)}?json=1&auth=#{auth_key}")
    puts response
    return error_response if is_error_response?(response)

    {
      title: add_title_to_response(@address, response),
      latitude: response["latt"],
      longitude: response["longt"]
    }
  end

  def add_title_to_response(address, response)
    return address unless is_zipcode?(address)

    "#{address}, #{response["standard"]["city"]}, #{response["standard"]["region"]}"
  end

  def throttled_response?(response)
    latitude = response["latt"]
    latitude.is_a?(String) && latitude.include?("Throttled!")
  end

  def is_error_response?(response)
    response["error"] || !response.success?
  end

  def is_zipcode?(address)
    address =~ /^\d{5}(?:[-\s]\d{4})?$/
  end

  def error_response(response)
    code = response.dig("error", "code")
    return { error: "Issues with API. Please try again." } if [ "002", "003", "006" ].include? code
    { error: "Your request did not produce any results. Check your spelling and try again." }
  end
end
