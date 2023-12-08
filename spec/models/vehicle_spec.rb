require 'rails_helper'

RSpec.describe Vehicle, type: :model do

  describe 'validations' do
    describe 'reg_no' do

      vehicle = Vehicle.new

      it 'should return blank error' do
        vehicle.reg_no  = ''
        vehicle.validate
        expect(vehicle.errors[:reg_no]).to include("can't be blank")
      end

      it 'should return invalid reg_no error' do
        vehicle.reg_no = 'TN458959AS'
        vehicle.validate
        expect(vehicle.errors[:reg_no]).to include("Not valid Indian vehicle Registration number")
      end

      describe '#reg_no' do
        it { should_not allow_value('TN45ABCD97').for(:reg_no) }
      end

    end
  end

end
