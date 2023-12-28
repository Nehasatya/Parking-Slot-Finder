class Entry < ApplicationRecord
  reverse_geocoded_by :lat, :lon, address: :location

  # Validations
  validates :lon,:lon, presence: true

  # Callbacks
  after_validation :reverse_geocode

end
