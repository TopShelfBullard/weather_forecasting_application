class IpapiService
  include HTTParty
  base_uri "https://ipapi.co"

  def initialize(ip)
    @ip = ip
  end

  def fetch_location
    response = self.class.get("/#{@ip}/json/")
    return nil if error_response?(response)

    {
      title: @ip,
      latitude: response["latitude"],
      longitude: response["longitude"]
    }
  end

  def error_response?(response)
    response["error"] || !response.success?
  end
end
