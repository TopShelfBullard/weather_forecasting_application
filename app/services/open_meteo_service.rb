class OpenMeteoService
  include HTTParty
  base_uri "https://api.open-meteo.com/v1"

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def fetch_forecast
    self.class.get("/forecast", query: forecast_query_params)
  end

  private

  def forecast_query_params
    {
      latitude: @latitude,
      longitude: @longitude,
      daily: "temperature_2m_max,temperature_2m_min",
      temperature_unit: "fahrenheit",
      timezone: "auto"
    }
  end
end
