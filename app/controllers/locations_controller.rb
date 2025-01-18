class LocationsController < ApplicationController
  def new
    @location = Location.new
  end

  def create
    user_input = params[:address]

    if user_input.blank?
      flash[:alert] = "Address or IP cannot be blank."
      redirect_to new_location_path and return
    end

    location_data = fetch_location_data(user_input)
    if location_data
      @location = Location.find_by(postal_code: location_data[:postal_code]) || Location.create(location_data)
      redirect_to location_forecast_path(@location)
    else
      flash[:alert] = "Unable to find the entered location."
      redirect_to new_location_path
    end
  end

  private

  def is_ip?(user_input)
    user_input =~ Resolv::IPv4::Regex || user_input =~ Resolv::IPv6::Regex
  end

  def fetch_location_data(user_input)
    service = is_ip?(user_input) ? IpapiService.new(user_input) : GeocodeService.new(user_input)
    service.fetch_location
  end
end
