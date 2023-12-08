require 'rails_helper'
require 'rspec/rails'

RSpec.describe Entry, type: :model do

  entry  = Entry.new

  it 'should return validation error' do
    entry.validate
    expect(entry.errors[:lon]).to include('can\'t be blank')
  end

  it 'should not return validation error' do
    should allow_value(11.12345).for(:lat)
    should allow_value(12.345678).for(:lon)
  end

end
