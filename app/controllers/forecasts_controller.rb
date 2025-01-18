class ForecastsController < ApplicationController
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
end
