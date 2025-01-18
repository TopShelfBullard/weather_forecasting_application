require "rails_helper"

RSpec.describe "Locations", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:mock_geocode_response) do
    {
      title: "12345: Address Test City, Address Test Region, Address Test Country",
      latitude: "12.3456",
      longitude: "-65.4321",
      postal_code: "12345"
    }
  end

  let(:mock_ipapi_response) do
    {
      title: "54321: IP Test City, IP Test Region, IP Test Country",
      latitude: "65.4321",
      longitude: "-12.3456",
      postal_code: "54321"
    }
  end

  let(:mock_failed_response) { nil }

  before do
    allow_any_instance_of(GeocodeService).to receive(:fetch_location).and_return(mock_geocode_response)
    allow_any_instance_of(IpapiService).to receive(:fetch_location).and_return(mock_ipapi_response)
  end

  describe "Adding locations" do
    it "allows the user to add a location by street address" do
      visit root_path

      expect(page).to have_content("Add a Location")
      fill_in "Enter Address or IP", with: "1234 First St, Inisfree, WI"
      click_button "Get Forecast"

      expect(page).to have_content("7-Day Forecast for 12345: Address Test City, Address Test Region, Address Test Country")

      location = Location.last
      expect(location.title).to eq("12345: Address Test City, Address Test Region, Address Test Country")
      expect(location.latitude).to eq("12.3456")
      expect(location.longitude).to eq("-65.4321")
      expect(location.postal_code).to eq("12345")
    end

    it "allows the user to add a location by ip" do
      visit root_path

      expect(page).to have_content("Add a Location")
      fill_in "Enter Address or IP", with: "8.8.8.8"
      click_button "Get Forecast"

      expect(page).to have_content("7-Day Forecast for 54321: IP Test City, IP Test Region, IP Test Country")

      location = Location.last
      expect(location.title).to eq("54321: IP Test City, IP Test Region, IP Test Country")
      expect(location.latitude).to eq("65.4321")
      expect(location.longitude).to eq("-12.3456")
      expect(location.postal_code).to eq("54321")
    end
  end

  describe "Error handling" do
    it "shows an error message when location cannot be found" do
      allow_any_instance_of(GeocodeService).to receive(:fetch_location).and_return(mock_failed_response)
      allow_any_instance_of(IpapiService).to receive(:fetch_location).and_return(mock_failed_response)

      visit root_path
      fill_in "Enter Address or IP", with: "invalid address"
      click_button "Get Forecast"

      expect(page).to have_content("Unable to find the entered location.")
    end

    it "shows an error message when the input is blank" do
      visit root_path
      click_button "Get Forecast"

      expect(page).to have_content("Address or IP cannot be blank.")
    end
  end
end
