require 'spec_helper'

describe Checkin do

  describe :validations do

    it 'is valid if user is present' do
      user = FactoryGirl.create(:user)
      checkin = Checkin.new(user: user)
      expect(checkin.valid?).to be true
    end

    it 'is invalid if no user is present' do
      checkin = Checkin.new
      expect(checkin.valid?).to be false
    end

  end

end