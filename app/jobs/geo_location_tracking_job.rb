class GeoLocationTrackingJob < ApplicationJob
  queue_as :default

  def perform(booking_id,ip)


    location = Geocoder.search(ip).first.coordinates
    lat = location[0]
    lon = location[1]

    # In dev env
    lat = 11.121476485488197 if lat.nil?
    lon =  77.35230020983042 if lon.nil?

    @booking = Booking.find(booking_id)

    distance = Geocoder::Calculations.distance_between(
      [lat,lon],
      [@booking.slot.lat,@booking.slot.lon],
      { :units => :km })

    if distance < 1 && @booking.in_time.nil?
      # For in_time
      @booking.update(in_time: Time.now)
      @vehicle = Vehicle.find(@booking.vehicle_id)
      if @vehicle.first_entry_time.nil?
        @vehicle.update(first_entry_time: Time.now)
      end
    elsif distance < 1 && ! @booking.in_time.nil? && @booking.out_time.nil?
      # For out_time
      @booking.update(out_time: Time.now)
      @booking.slot.update(status: 'Available')
    end
    @booking.save
    @vehicle.save if @vehicle
  end

end
