class LocationsController < ApplicationController
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    @locations = Current.user.locations.includes(:user)
    @forecasts = fetch_forecasts_for_locations(@locations)
    @new_location = Location.new
  end

  def new
    @location = Location.new
  end

  def show
    @location = Location.find(params[:location_id])
    service = OpenMeteoService.new(@location.latitude, @location.longitude)
    response = service.fetch_forecast

    if response && response["daily"]
      @forecast = response["daily"]
    else
      @forecast = nil
      flash[:alert] = "Unable to fetch forecast data. Please try again later."
    end
  end

  def create
    address = params[:address]
    if address.blank?
      flash[:alert] = "Address or IP cannot be blank."
      redirect_to locations_path and return
    end

    location_data = fetch_location_data(address)
    if location_data
      @location = Current.user.locations.find_by(
        latitude: location_data[:latitude],
        longitude: location_data[:longitude]
      ) || Current.user.locations.create(location_data)
      redirect_to location_path(@location)
    else
      flash[:alert] = "Unable to find the entered location."
      redirect_to locations_path
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      flash[:notice] = "Location title updated successfully."
      redirect_to locations_path
    else
      flash[:alert] = "Failed to update the location title."
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path
  end

  private

  def is_ip?(user_input)
    user_input =~ Resolv::IPv4::Regex || user_input =~ Resolv::IPv6::Regex
  end

  def fetch_location_data(user_input)
    service = is_ip?(user_input) ? IpapiService.new(user_input) : GeocodeService.new(user_input)
    service.fetch_location
  end

  def fetch_forecasts_for_locations(locations)
    locations.each_with_object({}) do |location, forecasts|
      service = OpenMeteoService.new(location.latitude, location.longitude)
      forecasts[location.id] = service.fetch_forecast
    end
  end

  def set_location
    @location = Current.user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:title)
  end
end
