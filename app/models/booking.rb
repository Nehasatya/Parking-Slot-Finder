class Booking < ApplicationRecord
  BILL_CHARGE = 20

  # Association
  belongs_to :vehicle
  belongs_to :slot

  # Validations
  validates :vehicle_id,:slot_id,presence: true

  # Callbacks
  after_update :calculate_bill

  #Scope
  scope :on_date, ->(date) {  where("DATE(in_time) = ?", date) }

  scope :on_same_reg_no, ->(reg_no) {
    vehicle = Vehicle.find_by(reg_no: reg_no)
    id = vehicle.id if vehicle
    where(vehicle_id: id)
  }

#   Methods
  def calculate_bill
    if !self.out_time.nil? && self.bill.nil?
      seconds = ((self.out_time - self.in_time)/3600)
      bill_amt = ((seconds) * BILL_CHARGE).round(2)
      self.update( :bill => bill_amt)
    end
  end

end
