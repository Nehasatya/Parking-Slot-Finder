class ApplicationController < ActionController::Base
  before_action :beforeFilter

  def beforeFilter
    $request = request
  end

  def lookup_ip_location
    if Rails.env.development?
      Geocoder.search(request.remote_ip).first
    else
      request.location
    end
  end

end
