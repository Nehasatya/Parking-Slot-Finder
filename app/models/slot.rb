class Slot < ApplicationRecord
  reverse_geocoded_by :lat, :lon, address: :location

  # Association
  has_many :bookings
  has_many :vehicles, through: :bookings

  # Validations
  validates :lon,:lat,:status, presence: true

  # Callback
  after_validation :reverse_geocode
  after_create :calculate_distance

#   Scope
  scope :available_slots, ->{ where(status: 'Available') }
  scope :nearest_slot, ->(entry) { order("distance_from_entry_point_#{entry.id} ASC").first}

#   Methods
  def calculate_distance
    # to calculate distance between each entry_point and current slot
    Entry.all.each do |entry|
      self.update_column("distance_from_entry_point_#{entry.id}",
                         Geocoder::Calculations.distance_between(
                           [entry.lat,entry.lon],
                           [self.lat,self.lon],
                           { :units => :km })*1000
                         )
    end
  end

end
