require "rails_helper"

RSpec.describe "Forecasts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:location) do
    Location.create!(
      title: "Test Location",
      latitude: "40.7128",
      longitude: "-74.0060",
      postal_code: "10001"
    )
  end

  let(:mock_forecast_response) do
    {
      "daily" => {
        "time" => ["1980-05-18", "1980-05-19"],
        "temperature_2m_max" => [80, 70],
        "temperature_2m_min" => [70, 60]
      }
    }
  end

  before do
    allow_any_instance_of(OpenMeteoService).to receive(:fetch_forecast).and_return(mock_forecast_response)
  end

  describe "Viewing a forecast" do
    it "displays the 7-day forecast for a location" do
      visit location_forecast_path(location)

      expect(page).to have_content("7-Day Forecast for Test Location")
      expect(page).to have_content("1980-05-18")
      expect(page).to have_content("High: 80°F")
      expect(page).to have_content("Low: 70°F")
      expect(page).to have_content("1980-05-19")
      expect(page).to have_content("High: 70°F")
      expect(page).to have_content("Low: 60°F")
    end
  end

  describe "Error handling for forecast" do
    before do
      allow_any_instance_of(OpenMeteoService).to receive(:fetch_forecast).and_return(nil)
    end

    it "shows an error message when forecast data cannot be fetched" do
      visit location_forecast_path(location)

      expect(page).to have_content("Unable to retrieve forecast data.")
    end
  end
end
