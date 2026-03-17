class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV.fetch("GOOGLE_MAPS_API_KEY", nil)
    @user_city = current_user&.city.presence
  end
end
