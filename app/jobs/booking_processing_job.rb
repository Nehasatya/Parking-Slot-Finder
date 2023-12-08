class BookingProcessingJob < ApplicationJob
  queue_as :default

  def perform(booking_id,user_ip)
    @booking = Booking.find(booking_id)
    if @booking&.in_time.nil? || @booking&.out_time.nil?
        GeoLocationTrackingJob.perform_later(booking_id,user_ip)
        self.class.set(wait: 1.minutes).perform_later(booking_id,user_ip)
    end
  end
end
