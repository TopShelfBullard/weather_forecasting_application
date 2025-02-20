require "rails_helper"

RSpec.describe "Locations", type: :system do
  before do
    driven_by(:rack_test)
    @user = login_as_test_user
  end

  let(:mock_geocode_response) do
    {
      latitude: "12.3456",
      longitude: "-65.4321"
    }
  end

  let(:mock_ipapi_response) do
    {
      latitude: "65.4321",
      longitude: "-12.3456"
    }
  end

  let(:mock_failed_response) { nil }

  before do
    allow_any_instance_of(GeocodeService).to receive(:fetch_location).and_return(mock_geocode_response)
    allow_any_instance_of(IpapiService).to receive(:fetch_location).and_return(mock_ipapi_response)
  end

  describe "Adding locations" do
    it "allows the user to add a location by street address" do
      visit locations_path

      expect(page).to have_content("No locations found.")
      expect(page).to have_content("Add a Location")

      fill_in "Title", with: "Home"
      fill_in "Enter Street Address, Zipcode, or IP Address", with: "1234 First St, Inisfree, WI"
      click_button "Get Forecast"

      expect(page).to have_content("7-Day Forecast for 1234 First St, Inisfree, WI")

      location = Location.last
      expect(location.title).to eq("Home")
      expect(location.latitude).to eq("12.3456")
      expect(location.longitude).to eq("-65.4321")

      visit locations_path

      expect(page).to have_content("Home")
    end

    it "allows the user to add a location by ip" do
      visit locations_path

      expect(page).to have_content("No locations found.")
      expect(page).to have_content("Add a Location")

      fill_in "Title", with: "Home"
      fill_in "Enter Street Address, Zipcode, or IP Address", with: "8.8.8.8"
      click_button "Get Forecast"

      expect(page).to have_content("7-Day Forecast for 8.8.8.8")

      location = Location.last
      expect(location.title).to eq("Home")
      expect(location.latitude).to eq("65.4321")
      expect(location.longitude).to eq("-12.3456")

      visit locations_path

      expect(page).to have_content("Home")
    end
  end

  describe "Deleting locations" do
    it 'allows the user to delete a location from the index page' do
      @user.locations.create!(
        title: "1234 First St, Inisfree, WI",
        latitude: "12.3456",
        longitude: "-65.4321"
      )

      visit locations_path
      expect(page).to have_content("1234 First St, Inisfree, WI")

      click_button "Delete"
      expect(page).not_to have_content("1234 First St, Inisfree, WI")
    end
  end

  describe "Editing locations" do
    it 'allows the user to edit a location title' do
      @user.locations.create!(
        title: "1234 First St, Inisfree, WI",
        latitude: "12.3456",
        longitude: "-65.4321"
      )

      visit locations_path
      expect(page).to have_content("1234 First St, Inisfree, WI")

      click_button "Edit"
      fill_in "Location Title", with: "Updated Location Title"
      click_button "Update Title"

      expect(page).to have_content("Updated Location Title")
    end
  end

  describe "Error handling" do
    it "shows an error message when location cannot be found" do
      allow_any_instance_of(GeocodeService).to receive(:fetch_location).and_return(nil)
      allow_any_instance_of(IpapiService).to receive(:fetch_location).and_return(nil)

      visit locations_path
      fill_in "Title", with: "Invalid Home"
      fill_in "Enter Street Address, Zipcode, or IP Address", with: "invalid address"
      click_button "Get Forecast"

      expect(page).to have_content("Unable to find the entered location.")
    end

    it "shows an error message when the input is blank" do
      visit locations_path
      click_button "Get Forecast"

      expect(page).to have_content("Address or IP cannot be blank.")
    end
  end
end
