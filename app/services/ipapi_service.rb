class IpapiService
  include HTTParty
  base_uri "https://ipapi.co"

  def initialize(ip)
    @ip = ip
  end

  def fetch_location
    response = self.class.get("/#{@ip}/json/")
    return nil unless response.success?

    {
      title: get_title_from_response(response),
      latitude: response["latitude"],
      longitude: response["longitude"],
      postal_code: response["postal"]
    }
  end

  def get_title_from_response(response)
    "#{response["postal"]}: #{response["city"]}, #{response["region"]}, #{response["country_name"]}"
  end
end
