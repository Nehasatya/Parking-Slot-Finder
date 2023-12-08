class Vehicle < ApplicationRecord

  # Association
  has_many :bookings
  has_many :slots, through: :bookings

  #Validations
  validate :custom_reg_no_validation


  #Methods
  def custom_reg_no_validation
    # to throw custom error message on reg_no field
    if reg_no.blank?
      errors.add(:reg_no, "can't be blank")
    elsif
      unless self.reg_no.match /\A[A-Z]{2}[ -]?[0-9]{2}[ -]?[A-Z]{1,2}[ -]?[0-9]{4}\z/
        errors.add(:reg_no, "Not valid Indian vehicle Registration number" )
      end
    end
  end
end
